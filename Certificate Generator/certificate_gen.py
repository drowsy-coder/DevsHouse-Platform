# Note - You need your own certificate file and participants.json file to run this code
# The json file should have atleast the f_name and l_name keys for each participant

from PIL import Image, ImageDraw, ImageFont
import os
import json

output_dir = "certificate"
os.makedirs(output_dir, exist_ok=True)

certificate_path = "Participants.png"
font_path = "QR Code/Hacker QR/Product Sans Regular.ttf"

json_file_path = 'participants.json'
with open(json_file_path, 'r', encoding='utf-8') as file:
    participants = json.load(file)

font_size = 50
font_color = (0, 0, 0)

x = 460
y = 500

for participant in participants:
    full_name = f"{participant['f_name']} {participant['l_name']}"

    image = Image.open(certificate_path).convert("RGBA")
    draw = ImageDraw.Draw(image)
    
    font = ImageFont.truetype(font_path, font_size)
    
    text_width = draw.textlength(full_name, font=font)
    
    text_height = font_size  
    
    # Optional: Adjust 'x' to be centered based on the text width if needed
    x = (1191 - text_width) / 2

    draw.text((x, y), full_name, font=font, fill=font_color)
    
    output_path = os.path.join(output_dir, f"{participant['f_name']} {participant['l_name']}.png")
    image.save(output_path)

print("Certificates generated successfully.")
