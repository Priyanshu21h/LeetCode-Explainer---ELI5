import os
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
"""

def build_user_prompt(code: str, mode: str) -> str:
    return f"Analyze this code:\n{code}\nMode: {mode}"

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
        temperature=0.3,
        max_tokens=4096,
    )

    # Extract the text content from the response
    response_text = response.choices[0].message.content.strip()
    
    # Sometimes the model wraps JSON in markdown blocks
    if response_text.startswith("```json"):
        response_text = response_text[7:]
    if response_text.startswith("```"):
        response_text = response_text[3:]
    if response_text.endswith("```"):
        response_text = response_text[:-3]
    response_text = response_text.strip()

    # Parse the JSON response
    try:
        result = json.loads(response_text)
    except json.JSONDecodeError as e:
        raise ValueError(f"Failed to parse AI response as JSON: {e}\nRaw response: {response_text}")

    # Validate required fields
    required_fields = ["explanation", "eli5", "complexity", "dry_run", "key_insight"]
    for field in required_fields:
        if field not in result:
            raise ValueError(f"Missing required field '{field}' in AI response.")

    return result
