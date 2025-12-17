import os
import subprocess

def convert_ui_files():
    project_dir = os.path.dirname(os.path.abspath(__file__))
    ui_dir = os.path.join(project_dir, 'ui')
    generated_dir = os.path.join(project_dir, 'generated')

    # Asegurarse de que el directorio 'generated' exista
    os.makedirs(generated_dir, exist_ok=True)

    # Crear un archivo __init__.py en 'generated' para que sea un paquete
    init_py_path = os.path.join(generated_dir, '__init__.py')
    if not os.path.exists(init_py_path):
        with open(init_py_path, 'w') as f:
            pass # Archivo vacío es suficiente
        print(f"Creado '{init_py_path}'")

    print(f"Buscando archivos .ui en: {ui_dir}")
    for filename in os.listdir(ui_dir):
        if filename.endswith(".ui"):
            ui_file = os.path.join(ui_dir, filename)
            py_file = os.path.join(generated_dir, f"ui_{os.path.splitext(filename)[0]}.py")
            command = f"pyside6-uic \"{ui_file}\" -o \"{py_file}\""
            print(f"Convirtiendo {filename} -> generated/ui_{os.path.splitext(filename)[0]}.py")
            try:
                subprocess.run(command, check=True, shell=True, capture_output=True, text=True)
            except subprocess.CalledProcessError as e:
                print(f"Error al convertir {filename}: {e.stderr}")

if __name__ == "__main__":
    convert_ui_files()
    print("\nConversión de archivos UI completada.")
