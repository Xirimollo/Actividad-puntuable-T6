grupos=0
existe=false
maxpersonas=0
maxgrupo=""
aparecidos="" #grupos que ya se sabe que estan repetidos
mkdir ./programCache
read -p "Introduce el fichero a analizar: " fichero 
if [ -f $fichero ]; then #si existe
	existe=true
fi
while [ $existe = false ]; do #mientras no exista el fichero sigue pidiendo un fichero
	echo "Error, el archivo no existe"
	read -p "Introduce el fichero a analizar: " fichero 
	if [ -f $fichero ]; then
	existe=true
fi
done 
while read line; do #cuenta los grupos y los organiza
	grupos=$(($grupos+1))
	echo $line > ./programCache/$grupos
done < $fichero
echo "Hay $grupos grupos"
for i in `seq 1 $grupos`; do #imprime el numero de usuarios de cada grupo
	personas=0
	for e in $(cat ./programCache/$i); do
		personas=$(($personas+1))
		if [ $personas -eq 1 ]; then
			grupo=$e
		fi
	done
	personas=$(($personas-1))
	if [ $maxpersonas -lt $personas ]; then
		maxpersonas=$personas
		maxgrupo=$i
	fi
	echo "$grupo hay $personas usuarios"
done
grupomax=$(cat ./programCache/$maxgrupo|awk '{print $1}')
echo "El grupo que tiene mas usuarios es $grupomax"
#codigo para determinar e imprimir grupos con el mismo numero de miembros
for i in `seq 1 $grupos`; do
	aparecido=0
	repetido=false #variable para determinar si hay algun grupo con el mismo numero de miembros
	for group in $aparecidos; do #busca si ya estuvo repetido el grupo
		if [ $i -eq $group ]; then
			aparecido=1
		fi
	done
	if [ $aparecido -eq 0 ]; then #si el grupo ya aparecio se lo salta
		contador1=0
		iguales=""
		primero=1
		for people in $(cat ./programCache/$i); do #Calcula las personas del primer grupo
			contador1=$(($contador1+1))	
		done

		for e in `seq $(($i+1)) $grupos`; do #calcula las personas desde grupo anterior hasta el final
			contador2=0
			for people in $(cat ./programCache/$e); do
				contador2=$(($contador2+1))	
			done
		
			if [ $contador1 -eq $contador2 ] && [ $primero -eq 1 ] ; then #si coinciden y es la primera vez:
				primero=0
				iguales=$iguales"$i $e"
				aparecidos=$aparecidos" $e"
				repetido=true
			
				else if [ $contador1 -eq $contador2 ] && [ $primero -eq 0 ]; then #si han habido mas de una coincidencia: 
					iguales=$iguales" $e"
					aparecidos=$aparecidos" $e"
				fi
			fi
		done
		if [ $repetido = true ]; then # si hubo algun repetido:
				echo "Grupos con los mismos numeros de miembros: "
				for i in $iguales; do
					while read line; do
						echo $line
					done < ./programCache/$i
				done
		fi
	fi
done

rm -rf ./programCache