#!/usr/bin/env python3
# Quest - a Generative AI ParaTools chatbot using OpenAI. 
# © 2024, ParaTools, Inc. All rights reserved. 
from openai import OpenAI
client = OpenAI()
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
         model="gpt-3.5-turbo",
         messages=conversation
      )
      answer_to_quest = response.choices[0].message.content.strip()
      print("ParaTools chatbot:", answer_to_quest)
      conversation.append({"role": "assistant", "content": answer_to_quest})

