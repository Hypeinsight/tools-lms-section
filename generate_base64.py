import base64
import os
import re

def encode_file_to_base64(file_path):
    """Read a file and return base64 encoded data URI"""
    with open(file_path, 'rb') as f:
        data = f.read()
    b64 = base64.b64encode(data).decode('utf-8')
    
    # Determine MIME type
    ext = os.path.splitext(file_path)[1].lower()
    mime_types = {
        '.svg': 'image/svg+xml',
        '.gif': 'image/gif',
        '.png': 'image/png',
        '.jpg': 'image/jpeg',
        '.jpeg': 'image/jpeg',
        '.mp4': 'video/mp4'
    }
    mime = mime_types.get(ext, 'application/octet-stream')
    
    return f'data:{mime};base64,{b64}'

def process_html(html_path, output_path):
    """Process HTML file and embed all external resources as base64"""
    print(f'Processing {html_path}...')
    
    with open(html_path, 'r', encoding='utf-8') as f:
        html = f.read()
    
    # Find all file references
    patterns = [
        (r'file:\s*"(.*?)"', 'file'),
        (r"file:\s*'(.*?)'", 'file'),
        (r'src:\s*"(.*?)"', 'src'),
        (r"src:\s*'(.*?)'", 'src'),
    ]
    
    replacements = {}
    base_dir = os.path.dirname(html_path)
    
    for pattern, attr_type in patterns:
        matches = re.finditer(pattern, html)
        for match in matches:
            file_ref = match.group(1)
            
            # Skip URLs
            if file_ref.startswith('http://') or file_ref.startswith('https://'):
                continue
            
            file_path = os.path.join(base_dir, file_ref)
            
            if os.path.exists(file_path):
                if file_ref not in replacements:
                    try:
                        data_uri = encode_file_to_base64(file_path)
                        replacements[file_ref] = data_uri
                        print(f'  Encoded: {file_ref}')
                    except Exception as e:
                        print(f'  Error encoding {file_ref}: {e}')
    
    # Replace all occurrences
    for file_ref, data_uri in replacements.items():
        html = html.replace(f'"{file_ref}"', f'"{data_uri}"')
        html = html.replace(f"'{file_ref}'", f"'{data_uri}'")
    
    # Write output
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html)
    
    print(f'Created {output_path}')
    print(f'Embedded {len(replacements)} files')
    print()

# Process both files
process_html('tools-competency-v12.html', 'tools-competency-v12-base64.html')
process_html('tools-competency-v12-swinburne.html', 'tools-competency-v12-swinburne-base64.html')

print('Base64 embedding complete!')
