import json
import qrcode
import os
from PIL import Image, ImageDraw, ImageFont
from fpdf import FPDF
import glob

def create_pdf(images, output_filename):
    pdf = FPDF('P', 'mm', 'A4')
    x, y = 10, 10
    w, h = 58, 69.51

    for i, image in enumerate(images):
        if i % 9 == 0:
            pdf.add_page()
            x, y = 10, 10

        pdf.image(image, x=x, y=y, w=w, h=h)

        x += w + 10
        if i % 3 == 2:
            x = 10
            y += h + 10

    pdf.output(output_filename, "F")

def add_text_to_image(image, text, table_number, team_name):
    new_image = Image.new("RGB", (image.width, image.height + 90), "white")
    new_image.paste(image, (0, 50))
    draw = ImageDraw.Draw(new_image)
    
    try:
        name_font = ImageFont.truetype("Product Sans Regular.ttf", 27)
        table_font = ImageFont.truetype("Product Sans Regular.ttf", 20)
        team_font = ImageFont.truetype("Product Sans Regular.ttf", 27)
    except IOError:
        name_font = ImageFont.load_default()
        table_font = ImageFont.load_default()
        team_font = ImageFont.load_default()
    
    _, _, text_width, text_height = draw.textbbox((0,0), text=text, font=name_font)
    text_x = (new_image.width - text_width) / 2
    text_y = image.height + 20
    draw.text((text_x, text_y), text, fill="black", font=name_font)
    
    table_text = f"Table Number: {table_number}"
    _, _, table_text_width, table_text_height = draw.textbbox((0,0), text=table_text, font=table_font)
    table_text_x = (new_image.width - table_text_width) / 2
    table_text_y = text_y + 30
    draw.text((table_text_x, table_text_y), table_text, fill="black", font=table_font)
    
    team_text = f"{team_name}"
    _, _, team_text_width, team_text_height = draw.textbbox((0,0), text=team_text, font=team_font)
    team_text_x = (new_image.width - team_text_width) / 2
    team_text_y = + 30
    draw.text((team_text_x, team_text_y), team_text, fill="black", font=team_font)
    
    return new_image

def add_icon_to_qr(qr_img, icon_path):
    icon = Image.open(icon_path)
    icon_size = qr_img.size[0] // 5, qr_img.size[1] // 5 
    icon.thumbnail(icon_size)
    icon_pos = ((qr_img.size[0] - icon.size[0]) // 2, (qr_img.size[1] - icon.size[1]) // 2)
    qr_img.paste(icon, icon_pos, mask=icon)
    return qr_img

with open('QR Code Generator/devshouse - finalist.json', 'r') as file:
    participants = json.load(file)

final_qr_folder = "Final_QR"
os.makedirs(final_qr_folder, exist_ok=True)

for participant in participants:
    unique_id = participant['unique_id']

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

    #This is flutter code, similar implememtation is given in QR Code implementation in the app, please refer that

    # void _onQRViewCreated(QRViewController controller) {
    # this.controller = controller;
    # controller.scannedDataStream.listen((scanData) {
    #   controller.pauseCamera();
    #   final Uri? uri = Uri.tryParse(scanData.code!);
    #   final String? uniqueId =
    #       uri!.pathSegments.isNotEmpty ? uri.pathSegments.last : null;


    img = qr.make_image(fill_color="black", back_color="white").convert('RGB')

    # here, you can replace it with your own icon which will appear in center of the QR code
    img_with_icon = add_icon_to_qr(img, 'Sticker-06.png')

    full_name = f"{participant['f_name'].upper()} {participant['l_name'].upper()}"
    img_with_text = add_text_to_image(img_with_icon, full_name, participant['table_number'], participant['team_name'])
    
    team_folder = os.path.join(final_qr_folder, f"{participant['table_number']} - {participant['team_name']}")
    os.makedirs(team_folder, exist_ok=True)
    
    filename = os.path.join(team_folder, f"{participant['f_name']}_{participant['l_name']}_{participant['table_number']}.png")
    img_with_text.save(filename)

images = glob.glob(f"{final_qr_folder}/**/*.png")
create_pdf(images, "qr_codes.pdf")