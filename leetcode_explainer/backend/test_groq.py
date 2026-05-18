import asyncio
from dotenv import load_dotenv
from groq import AsyncGroq
import os

load_dotenv()

async def test():
    api_key = os.environ.get("GROQ_API_KEY")
    print(f"Key found: {api_key[:10]}...{api_key[-5:]}")
    client = AsyncGroq(api_key=api_key)
    try:
        resp = await client.chat.completions.create(
            model="llama-3.3-70b-versatile",
            messages=[{"role": "user", "content": "say hi in one word"}],
            max_tokens=10,
        )
        print(f"SUCCESS: {resp.choices[0].message.content}")
    except Exception as e:
        print(f"ERROR TYPE: {type(e).__name__}")
        print(f"ERROR: {e}")

asyncio.run(test())
