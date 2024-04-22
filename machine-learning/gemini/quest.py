#!/usr/bin/env python3
# Quest - a Generative AI ParaTools chatbot using Google Gemini. 
# © 2024, ParaTools, Inc. All rights reserved. 
import google.generativeai as genai
import os
genai.configure(api_key=os.environ["GOOGLE_API_KEY"])
conversation = []
model_used = 'gemini-pro'
#print ("Model requested: ", model_used, " models available: ")
#for m in genai.list_models():
#    if 'generateContent' in m.supported_generation_methods:
#        print(m.name)

model = genai.GenerativeModel(model_used)
chat = model.start_chat(history=[])

while True: 
   print("What is your quest?")
   users_quest=input()
   if users_quest.lower() == "quit":
      print("Bye!")
      break
   else:
      response = chat.send_message(users_quest)
      print("ParaTools chatbot:", response.text)
