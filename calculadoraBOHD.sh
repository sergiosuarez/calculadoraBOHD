#!/bin/bash
# Titulo:        calculadoraBOHD.sh
# Autores:       Sergio Suarez, Blanca Alvez
# Objetivo del script:      Calcular o convertir numeros de una base a otra.
# Requerimientos: BASH shell, libreria BC.
# Materia:	  Fundamentos de Linux

######################################
#Simbologia: 
# -dec = decimal
# -bin = binario
# -hex = hexadecimal
# -oct = octal
##################################################################################################################
# Funcionamiento de Argumentos:
# Parametro #1: $1 es la base del numero que sera convertido o calculado (-dec, -hex, -bin, -oct)
# Parametro #2: $2 es el numero que sera convertido o calculado
# Parametro #3: $3 es el numero de la base que sera convertido o calculado (-dec, -hex, -bin, -oct)
##################################################################################################################
#Ejemplo de Uso: 
# ./calculadoraBOHD.sh -dec 15 -bin    convertira o calculara el decimal (-dec para decimal) 15 al binario (-bin  BINARY). El resultado seria F
################################################################################################################################################


# Esta linea valida que la entrada del argumento sea mayusculas para comodidad del calculo
numero=$( echo "$2" | tr -s '[:lower:]' '[:upper:]' )

# Verificando errores de ingreso de datos
if [ $# = 0 ]; then echo "Ingresa un argumento"; exit; fi

######################################
# 1. Configurando el tipo de entrada #
######################################
if [ "$1" = "-bin" ]; then   
    TipoIN='2'
elif [ "$1" = "-oct" ]; then 
    TipoIN=8   
elif [ "$1" = "-dec" ]; then 
    TipoIN=10
elif [ "$1" = "-hex" ]; then 
    TipoIN=16
fi

#####################################
# 2. Configurando el tipo de salida #
#####################################
if [ "$3" = "-bin" ]; then    
    TipoOUT='2'
elif [ "$3" = "-oct" ]; then  
    TipoOUT=8   
elif [ "$3" = "-dec" ]; then  
    TipoOUT='10'
elif [ "$3" = "-hex" ]; then  
    TipoOUT=16
fi

############################
# 3. Ejecutando el calculo #
############################
resultado=$(echo "obase=$TipoOUT;ibase=$TipoIN;$numero" | bc); echo $resultado

###################################################################################################################
function terminar () {
  # la mejor opcion para salir de un error en los procesos
  echo "$1"
  exit 1

}
 
function calcular() {
  numero=$( echo "$3" | tr -s '[:lower:]' '[:upper:]' )
  resultado=$(echo "obase=$2;ibase=$1;$numero" | bc)
  if [ ! "$?" == "0" ]; then
    terminar "Error en libreria bc: valores incorrectos."
  fi
  echo "Numero original en base $1: $numero"
  echo "Numero convertido en base $2: $resultado"
}
 
# Verificando errores
if [ $# = 0 ]; then terminar "Debes ingresar un argumento valido."; fi

# Valores predeterminados
TipoIN=10
TipoOUT=16

while [ -n "$1" ]; do
  case "$1" in
    -i|--input-base)
      if [ -n "$2" ]; then
        TipoIN="$2"
      else
        terminar "  $1 requiere un parametro adicional."
      fi
      shift; shift;
      ;;
    -o|--output-base)
      if [ -n "$2" ]; then
        TipoOUT="$2"
      else
        terminar "  $1  requiere un parametro adicional."
      fi
      shift; shift;
      ;;
    *)
      calcular $TipoIN $TipoOUT $1
      shift;
      ;;
  esac
done
