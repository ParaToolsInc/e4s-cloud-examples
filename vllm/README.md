Use run-smaller.sh on servers with 16GB of memory or less to run a compact model, otherwise use run.sh which will load the full meta-llama model. 

If the server fails to launch becaose of a port in use you can add something like  "--port 8585" to the server launch command in the run script.

After the server is launched in the background, with its output piped to server.log, the gradio script will launch a web based chat server and print two urls. The local url can be used in a local web browser and the public url should be functional anywhere. Please make sure to free ports and resources by killing this script when not in use.

This example was adapted from VLLM documentation: https://docs.vllm.ai/en/v0.8.0/getting_started/examples/gradio_webserver.html and the webserver script obtained via: wget https://raw.githubusercontent.com/vllm-project/vllm/refs/heads/main/examples/online_serving/gradio_openai_chatbot_webserver.py

