# Save this script as 'multipart_upload_script.py'

import sys
from s3_multipart_upload import (
    upload_with_default_configuration,
    upload_with_chunksize_and_meta,
    upload_with_high_threshold,
    upload_with_sse,
)

def main():
    # Replace these values with your AWS S3 and file details
    local_file_path = "/Users/logpoint//Downloads/OpenServer-6.0.0Ni-2006-02-08-1513.iso"
    bucket_name = "testingpythonmulti"
    object_key = "/Users/logpoint//Downloads/OpenServer-6.0.0Ni-2006-02-08-1513.iso"
    file_size_mb = 50  # Size of the file in megabytes

    print("Performing multipart upload with default configuration...")
    thread_info_default = upload_with_default_configuration(local_file_path, bucket_name, object_key, file_size_mb)
    print("\nMultipart upload with default configuration complete.")
    print("Thread information:", thread_info_default)

    # print("\nPerforming multipart upload with custom chunk size and metadata...")
    # metadata = {"key1": "value1", "key2": "value2"}
    # thread_info_chunk_meta = upload_with_chunksize_and_meta(local_file_path, bucket_name, object_key, file_size_mb, metadata=metadata)
    # print("\nMultipart upload with custom chunk size and metadata complete.")
    # print("Thread information:", thread_info_chunk_meta)

    # print("\nPerforming multipart upload with high threshold...")
    # thread_info_high_threshold = upload_with_high_threshold(local_file_path, bucket_name, object_key, file_size_mb)
    # print("\nMultipart upload with high threshold complete.")
    # print("Thread information:", thread_info_high_threshold)

    # # Provide an SSE key for server-side encryption
    # sse_key = "your-sse-key"
    # print("\nPerforming multipart upload with server-side encryption...")
    # thread_info_sse = upload_with_sse(local_file_path, bucket_name, object_key, file_size_mb, sse_key=sse_key)
    # print("\nMultipart upload with server-side encryption complete.")
    # print("Thread information:", thread_info_sse)

if __name__ == "__main__":
    main()

