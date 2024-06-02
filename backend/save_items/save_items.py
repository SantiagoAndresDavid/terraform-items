import base64
import boto3
import json
import pymysql
import uuid
import os

# Configura la conexión a tu base de datos RDS usando variables de entorno
TABLE_NAME = "items_data"
endpoint = 'database-1.cns8a4ikg5db.us-west-2.rds.amazonaws.com'
username = 'admin'
password = '123456789pwd'
database_name = 'items'
port = 3306

# Inicializa los clientes de boto3
s3_client = boto3.client('s3')

headers = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,Access-Control-Request-Headers",
}

def handle(event, context):
    # Verifica que el evento contiene los datos necesarios
    if 'file' not in event or 'fileName' not in event or 'fileType' not in event:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"error": "Missing 'file', 'fileName', or 'fileType' in the event"})
        }

    id = str(uuid.uuid4())
    file_content_base64 = event["file"]
    file_name = event["fileName"]
    file_extension = file_name.split('.')[-1]
    target_file = f'data/{file_name}-{id}.{file_extension}'

    connection = None

    try:
        # Decodificar el archivo Base64
        file_content = base64.b64decode(file_content_base64)

        # Guardar el archivo en S3
        s3_client.put_object(Bucket='items-01', Key=target_file, Body=file_content, ContentType=event["fileType"])

        # Establecer la conexión a la base de datos
        connection = pymysql.connect(host=endpoint, user=username, password=password, db=database_name, port=port)
        cursor = connection.cursor()

        # Insertar el nuevo registro en la base de datos
        sql = "INSERT INTO {} (Id, FileName, FileType) VALUES (%s, %s, %s)".format(TABLE_NAME)
        cursor.execute(sql, (id, file_name, file_extension))

        # Commit para asegurarse de que los cambios se guarden en la base de datos
        connection.commit()
        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({
                "id": id,
                "title": file_name,
            })
        }
    except pymysql.MySQLError as e:
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"error": "Database error", "message": str(e)})
        }
    except boto3.exceptions.Boto3Error as e:
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"error": "S3 error", "message": str(e)})
        }
    except Exception as e:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"error": "Request processing error", "message": str(e)})
        }
    finally:
        # Asegurar que la conexión se cierra
        if connection:
            connection.close()
