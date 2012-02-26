-- Adds the preferences to the preferences table.
INSERT INTO preference(p_key, p_value) VALUES 
    ('document_directory', '/opt/aw/userdata/documents'), 
    ('image_directory', '/opt/aw/userdata/images'), 
    ('max_files_per_dir', '1000'), 
    ('document_depth', '5'), 
    ('visualization_server_address', 'http://rdev.mobilizingcs.org/R/call/Mobilize/'), 
    ('properties_file', '/opt/aw/as/webapps/app/META-INF/system.properties');
