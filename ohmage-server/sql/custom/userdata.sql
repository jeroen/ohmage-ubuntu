-- Update preferences for Linux package
UPDATE preference SET p_value='/var/lib/ohmage/documents' WHERE p_key='document_directory';
UPDATE preference SET p_value='/var/lib/ohmage/images' WHERE p_key='image_directory';
UPDATE preference SET p_value='/var/lib/ohmage/videos' WHERE p_key='video_directory';
UPDATE preference SET p_value='/var/log/ohmage/audits' WHERE p_key='audit_log_location';

