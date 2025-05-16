: '
    Bash file that reads the parameters from a script
    Code created by Deepseek.
'

input_file="$1"

# Validar existencia del archivo
if [ ! -f "$input_file" ]; then
  echo "Error: El archivo '$input_file' no existe!"
  exit 1
fi

# Crear archivo temporal para variables
tmp_vars=$(mktemp)

# Procesar CSV y generar variables
{
  # Leer cabecera y limpiar nombres
  IFS=, read -ra cabecera
  declare -a cabecera_limpia=()
  
  for campo in "${cabecera[@]}"; do
    cabecera_limpia+=("${campo//-/_}")
  done

  # Leer líneas de datos
  while IFS=, read -ra datos; do
    # Crear asignaciones de variables
    for i in "${!cabecera_limpia[@]}"; do
      if [ $i -lt ${#datos[@]} ]; then
        valor="${datos[i]//\"/}"  # Remover comillas si existen
        echo "declare -g ${cabecera_limpia[i]}=\"${valor}\""
      fi
    done
  done
} < "$input_file" > "$tmp_vars"

# Cargar variables en el entorno actual
source "$tmp_vars"

# Limpieza y verificación
rm "$tmp_vars"

