#!/usr/bin/env python3
# Quest - a Generative AI ParaTools chatbot using OpenAI. 
# © 2024, ParaTools, Inc. All rights reserved. 
from openai import OpenAI
import os
YOUR_API_KEY = os.environ["PERPLEXITY_API_KEY"]
client = OpenAI(api_key=YOUR_API_KEY, base_url="https://api.perplexity.ai")
conversation = []

while True: 
   print("What is your quest?")
   users_quest=input()
   if users_quest.lower() == "quit":
      print("Bye!")
      break
   else:
      conversation.append({"role": "user", "content": users_quest})
      response = client.chat.completions.create(
#         model="gpt-3.5-turbo",
         model="llama-3.1-sonar-small-128k-online",
         messages=conversation
      )
      answer_to_quest = response.choices[0].message.content.strip()
      print("ParaTools chatbot:", answer_to_quest)
      conversation.append({"role": "assistant", "content": answer_to_quest})

