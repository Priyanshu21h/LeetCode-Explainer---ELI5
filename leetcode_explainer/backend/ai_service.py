import os
import re
import json
from dotenv import load_dotenv
from groq import AsyncGroq

# Load .env file so GROQ_API_KEY is always available
load_dotenv(override=True)

SYSTEM_PROMPT = """You are an expert code analyst. When given code, you must analyze it and return ONLY a valid JSON object with no additional text, markdown formatting, or code fences. The JSON must follow this exact schema:

{
  "explanation": "A clear, plain English walkthrough of what the code does, step by step.",
  "eli5": "A real-world analogy that explains the algorithm in a way a 5-year-old could understand.",
  "complexity": {
    "time": "The time complexity in Big-O notation with a brief reason (e.g., 'O(n) — single pass through the array').",
    "space": "The space complexity in Big-O notation with a brief reason (e.g., 'O(n) — hash map stores up to n elements')."
  },
  "dry_run": [
    {
      "step": 1,
      "line": "the line of code being executed",
      "state": "current variable values after this step",
      "note": "brief explanation of what happened"
    }
  ],
  "key_insight": "The core algorithmic idea summarized in one sentence."
}

Rules:
- Return ONLY the JSON object. No markdown, no code fences, no extra text before or after.
- The dry_run should use a small representative example input and trace through 5-10 key steps.
- If mode is "eli5", make the explanation and eli5 fields extra simple and fun, using everyday analogies.
- If mode is "normal", keep the explanation technical but accessible.
- Always provide accurate complexity analysis with reasoning.
- All string values must be properly escaped. Do not use newlines inside JSON string values.
"""

def build_user_prompt(code: str, mode: str) -> str:
    return f"Analyze this code:\n{code}\nMode: {mode}"


def _extract_json(text: str) -> str:
    """
    Robustly extract a JSON object from a response that may contain
    markdown fences, preamble, or extra trailing text.
    """
    # 1. Strip leading/trailing whitespace
    text = text.strip()

    # 2. Remove ```json ... ``` or ``` ... ``` fences (greedy inner match)
    fence_match = re.search(r"```(?:json)?\s*([\s\S]*?)```", text)
    if fence_match:
        text = fence_match.group(1).strip()

    # 3. Find the outermost { ... } block in case there's surrounding prose
    brace_match = re.search(r"\{[\s\S]*\}", text)
    if brace_match:
        text = brace_match.group(0)

    return text


async def get_code_explanation(code: str, mode: str) -> dict:
    """Send code to Groq API and return the parsed explanation dict."""
    api_key = os.environ.get("GROQ_API_KEY")
    if not api_key:
        raise ValueError("GROQ_API_KEY environment variable is not set.")

    client = AsyncGroq(api_key=api_key)

    user_prompt = build_user_prompt(code, mode)

    response = await client.chat.completions.create(
        model="llama-3.3-70b-versatile",
        messages=[
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": user_prompt},
        ],
        temperature=0.2,       # lower = more deterministic JSON
        max_tokens=4096,
        response_format={"type": "json_object"},  # force JSON mode on Groq
    )

    # Extract the text content from the response
    raw = response.choices[0].message.content or ""

    # Robustly extract the JSON object
    response_text = _extract_json(raw)

    # Parse the JSON response
    try:
        result = json.loads(response_text)
    except json.JSONDecodeError as e:
        raise ValueError(
            f"Failed to parse AI response as JSON: {e}\n"
            f"Raw response (first 500 chars): {raw[:500]}"
        )

    # Provide safe defaults for any missing fields so the app never crashes
    result.setdefault("explanation", "No explanation provided.")
    result.setdefault("eli5", "No ELI5 provided.")
    result.setdefault("key_insight", "No key insight provided.")

    if "complexity" not in result or not isinstance(result["complexity"], dict):
        result["complexity"] = {"time": "N/A", "space": "N/A"}
    result["complexity"].setdefault("time", "N/A")
    result["complexity"].setdefault("space", "N/A")

    if "dry_run" not in result or not isinstance(result["dry_run"], list):
        result["dry_run"] = []

    # Sanitise dry_run rows
    sanitised = []
    for i, step in enumerate(result["dry_run"]):
        if isinstance(step, dict):
            sanitised.append({
                "step": int(step.get("step", i + 1)),
                "line": str(step.get("line", "")),
                "state": str(step.get("state", "")),
                "note": str(step.get("note", "")),
            })
    result["dry_run"] = sanitised

    return result
