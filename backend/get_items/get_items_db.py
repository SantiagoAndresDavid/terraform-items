import boto3
import json
import pymysql

# Configura la conexión a tu base de datos RDS
rds_client = boto3.client('rds')

endpoint = 'database-1.cns8a4ikg5db.us-west-2.rds.amazonaws.com'
username = 'admin'
password = '123456789pwd'
database_name = 'items'
port = 3306

connection = pymysql.connect(host=endpoint,user=username,password=password,db=database_name,port=port)
TABLE_NAME = "items_data"
cursor = connection.cursor()
headers = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
}

def handle(event, context):
    try:
        # Ejecutar una consulta para obtener todos los items de la tabla
        sql = "SELECT * FROM {}".format(TABLE_NAME)
        cursor.execute(sql)
        # Obtener todos los resultados
        items = cursor.fetchall()
        print(items)
        # Convertir los resultados a un formato JSON
        items_json = [{'Id': item[0], 'FileName': item[1], 'FileType': item[2]} for item in items]
        
        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps(items_json),
        }
    except Exception as e:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"error": str(e)})
        }

