import base64
import os
import re
from pathlib import Path

def get_mime_type(filename):
    """Get MIME type based on file extension"""
    ext = Path(filename).suffix.lower()
    mime_types = {
        '.svg': 'image/svg+xml',
        '.png': 'image/png',
        '.jpg': 'image/jpeg',
        '.jpeg': 'image/jpeg',
        '.gif': 'image/gif',
        '.mp4': 'video/mp4',
    }
    return mime_types.get(ext, 'application/octet-stream')

def encode_file_to_base64(file_path):
    """Read a file and encode it as base64 data URI"""
    try:
        with open(file_path, 'rb') as f:
            data = f.read()
            b64_data = base64.b64encode(data).decode('utf-8')
            mime_type = get_mime_type(file_path)
            return f'data:{mime_type};base64,{b64_data}'
    except Exception as e:
        print(f"Error encoding {file_path}: {e}")
        return None

def find_file(base_dir, relative_path):
    """Find a file given a relative path"""
    # Try the path as-is
    full_path = os.path.join(base_dir, relative_path)
    if os.path.exists(full_path):
        return full_path
    
    # Try with backslashes instead of forward slashes
    relative_path_win = relative_path.replace('/', '\\')
    full_path = os.path.join(base_dir, relative_path_win)
    if os.path.exists(full_path):
        return full_path
    
    return None

def create_embedded_html(source_html_path, output_html_path):
    """Create an embedded version of the HTML with all resources as base64"""
    
    base_dir = os.path.dirname(source_html_path)
    
    # Read the source HTML
    with open(source_html_path, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    # Find all file references in the JavaScript components array
    # Pattern: file: "path/to/file.ext", src: "path/to/file.ext", url: "path/to/file.ext" (in overlays)
    file_pattern = re.compile(r'file:\s*"([^"]+)"')
    src_pattern = re.compile(r'src:\s*"([^"]+)"')
    # Only match url: patterns that are file paths (not http:// or https://)
    url_pattern = re.compile(r'url:\s*"(?!https?://)([^"]+)"')
    
    files_to_embed = set()
    
    # Find all file references
    for match in file_pattern.finditer(html_content):
        files_to_embed.add(match.group(1))
    
    for match in src_pattern.finditer(html_content):
        files_to_embed.add(match.group(1))
    
    for match in url_pattern.finditer(html_content):
        files_to_embed.add(match.group(1))
    
    print(f"Found {len(files_to_embed)} unique files to embed")
    
    # Create a mapping of original paths to base64 data URIs
    file_mapping = {}
    for file_ref in files_to_embed:
        file_path = find_file(base_dir, file_ref)
        if file_path and os.path.exists(file_path):
            print(f"Encoding: {file_ref}")
            data_uri = encode_file_to_base64(file_path)
            if data_uri:
                file_mapping[file_ref] = data_uri
        else:
            print(f"WARNING: File not found: {file_ref}")
    
    # Replace all file references with data URIs
    for original_path, data_uri in file_mapping.items():
        # Escape special regex characters in the path
        escaped_path = re.escape(original_path)
        # Replace in file:, src:, and url: contexts
        html_content = re.sub(
            f'(file|src|url):\\s*"{escaped_path}"',
            lambda m: f'{m.group(1)}: "{data_uri}"',
            html_content
        )
    
    # Write the embedded HTML
    with open(output_html_path, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    print(f"\nCreated embedded HTML: {output_html_path}")
    print(f"Embedded {len(file_mapping)} files")

if __name__ == '__main__':
    # List of files to convert
    files_to_convert = [
        ('edu-activation-swinburne.html', 'edu-activation-swinburne-hubspot.html'),
    ]
    
    base_dir = r'C:\Users\Isuru\Special Projects\tools-lms-section'
    output_dir = r'C:\Users\Isuru\Special Projects\tools-lms-section\final-for-hubspot'
    
    for source_file, output_file in files_to_convert:
        source = os.path.join(base_dir, source_file)
        output = os.path.join(output_dir, output_file)
        
        print(f"\n{'='*60}")
        print(f"Creating embedded version of {source_file}...\n")
        create_embedded_html(source, output)
        print(f"{'='*60}")
