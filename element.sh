#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Verifica si se proporcionó un argumento
if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Determina si el argumento es un número o texto
if [[ "$1" =~ ^[0-9]+$ ]]; then
  # Buscar usando atomic_number
  NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
else
  # Buscar usando symbol o name
  NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
fi

# Verifica si se encontró el número atómico
if [[ -n "$NUMBER" ]]; then
  # Obtener los datos del elemento usando el atomic_number encontrado
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$NUMBER")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$NUMBER")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$NUMBER")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$NUMBER")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$NUMBER")

  # Muestra la información del elemento
  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
else
  echo "I could not find that element in the database."
fi
