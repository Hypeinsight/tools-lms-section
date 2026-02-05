import xml.etree.ElementTree as ET
import os
import json

mba_dir = r"MBA"
svg_files = sorted([f for f in os.listdir(mba_dir) if f.endswith('.svg')])

results = {}

for svg_file in svg_files:
    filepath = os.path.join(mba_dir, svg_file)
    print(f"\n{'='*60}")
    print(f"File: {svg_file}")
    print('='*60)
    
    try:
        tree = ET.parse(filepath)
        root = tree.getroot()
        
        # Get SVG dimensions
        width = root.get('width', 'unknown')
        height = root.get('height', 'unknown')
        print(f"Dimensions: {width}x{height}")
        
        # Find all <a> tags with href
        ns = {'svg': 'http://www.w3.org/2000/svg', 'xlink': 'http://www.w3.org/1999/xlink'}
        links = []
        
        for a in root.iter('{http://www.w3.org/2000/svg}a'):
            href = a.get('{http://www.w3.org/1999/xlink}href', '')
            if href:
                # Find rect inside the <a> tag
                rect = a.find('{http://www.w3.org/2000/svg}rect')
                if rect is not None:
                    x = rect.get('x', '0')
                    y = rect.get('y', '0')
                    w = rect.get('width', '0')
                    h = rect.get('height', '0')
                    
                    link_info = {
                        'href': href,
                        'x': x,
                        'y': y,
                        'width': w,
                        'height': h
                    }
                    links.append(link_info)
                    print(f"  Link: {href[:60]}...")
                    print(f"    Position: x={x}, y={y}, w={w}, h={h}")
        
        if not links:
            print("  No links found")
        
        results[svg_file] = {
            'width': width,
            'height': height,
            'links': links
        }
        
    except Exception as e:
        print(f"  Error parsing: {e}")
        results[svg_file] = {'error': str(e)}

# Save to JSON
with open('mba_links.json', 'w') as f:
    json.dump(results, f, indent=2)

print(f"\n\nResults saved to mba_links.json")
