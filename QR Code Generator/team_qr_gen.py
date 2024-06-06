import json
import qrcode
import os
import glob
from PIL import Image, ImageDraw, ImageFont
from fpdf import FPDF

def create_pdf(images, output_filename):
    pdf = FPDF('L', 'mm', 'A4')  
    w, h = 130, 140  

    for i, image in enumerate(images):
        if i % 2 == 0:
            pdf.add_page()
            x = (pdf.w / 4) - (w / 2)  

        pdf.image(image, x=x, y=20, w=w, h=h)

        if i % 2 == 1:
            x = (pdf.w / 4) - (w / 2)  
        else:
            x = (3 * pdf.w / 4) - (w / 2)  

    pdf.output(output_filename, "F")


def add_icon_to_qr(qr_img, icon_path):
    icon = Image.open(icon_path)
    icon_size = qr_img.size[0] // 5, qr_img.size[1] // 5
    icon.thumbnail(icon_size)
    icon_pos = ((qr_img.size[0] - icon.size[0]) // 2, (qr_img.size[1] - icon.size[1]) // 2)
    qr_img.paste(icon, icon_pos, mask=icon)
    return qr_img


def add_text_to_image(image, table_number, team_name):
    new_image = Image.new("RGB", (image.width, image.height + 80), "white")
    new_image.paste(image, (0, 60))
    draw = ImageDraw.Draw(new_image)

    try:
        table_font = ImageFont.truetype("Product Sans Regular.ttf", 27)
        team_font = ImageFont.truetype("Product Sans Regular.ttf", 30)
    except IOError:
        table_font = ImageFont.load_default()
        team_font = ImageFont.load_default()

    team_text = f"{team_name}"
    _, _, team_text_width, team_text_height = draw.textbbox((0,0), text=team_text, font=team_font)
    team_text_x = (new_image.width - team_text_width) / 2
    team_text_y = 20
    draw.text((team_text_x, team_text_y), team_text, fill="black", font=team_font)

    table_text = f"Table Number: {table_number}"
    _, _, table_text_width, table_text_height = draw.textbbox((0,0), text=table_text, font=table_font)
    table_text_x = (new_image.width - table_text_width) / 2
    table_text_y = new_image.height - 40
    draw.text((table_text_x, table_text_y), table_text, fill="black", font=table_font)

    return new_image

with open('teams.json', 'r') as file:
    teams = json.load(file)

final_qr_folder = "Team_QR"
os.makedirs(final_qr_folder, exist_ok=True)

for team in teams:
    unique_id = team['team_name']

    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_H,
        box_size=10,
        border=4,
    )

    # change the link to your own hackathon end_point
    # if you do not want to use deep linking, you can use a basic method which is discussed in the flutter code

    qr.add_data(f"team.devshouse.tech/{unique_id}")
    qr.make(fit=True)

    img = qr.make_image(fill_color="black", back_color="white").convert('RGB')
    img_with_icon = add_icon_to_qr(img, 'QR Code/Hacker QR/Sticker-06.png')

    img_with_text = add_text_to_image(img, team['table_number'], team['team_name'])

    filename = os.path.join(final_qr_folder, f"{team['table_number']} - {team['team_name']}.png")
    img_with_text.save(filename)

images = glob.glob(f"{final_qr_folder}/*.png")
create_pdf(images, "team_qr.pdf")