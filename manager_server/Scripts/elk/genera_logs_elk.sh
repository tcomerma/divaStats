#!/bin/bash
###############################################################################
#  genera_logs_elk.sh
#  Script que genera logs de diva, connectant per sqlplus i els envia a la
#  maquina on s'executa logstash per carregar-ho a elk.
#  NOTA: Requereix que hi hagi una clau ssh de l'usuari del ELK_SERVER en
#        l'usuari en que s'executa aquest script
#
#  Parametres:
#    $1: Dia a generar logs en format "yyyy-mm-dd"
#    $2, $3: Tipus de logs a generar: Valors valids: "requests events". Poden ser
#            un o dos valors
###############################################################################
DIR_BASE="/cygdrive/c/Scripts/elk"
DIR_BASE_WINDOWS="c:\\scripts\\elk"
DIR_LOG="${DIR_BASE}/tmp"
DIR_HISTORIC="${DIR_BASE}/historic"
TIPUS_FITXERS="requests events"
ELK_SERVER="logstash@ELK_SERVER:/var/data/logstash/diva"
ORACLE_USER="XXXX/XXXX"


if [ -z "$1" ]
then
  data=`date -d "-1 day" "+%Y-%m-%d"`

else
  data=$1
fi
echo "Processant data $data"

if [ -z "$2 $3" ]
then
  TIPUS_FITXERS="$2 $3"
fi
echo "Processant tipus: $TIPUS_FITXERS"

  # Loop per tipus de peticions
  for t in $TIPUS_FITXERS
  do
    # Ja s'ha generat el fitxer a historic?
    if [ ! -f $DIR_HISTORIC/${t}_$data.log.gz ]
    then
      # Generar fitxer
      sqlplus -s $ORACLE_USER "@$DIR_BASE_WINDOWS\\$t.sql" $data > $DIR_LOG/${t}_$data.log 2> $DIR_LOG/${t}_$data.err
      if  [ $? -ne 0 ]
      then
         # Ha fallat sqlplus
         echo "Error en SQLPlus"
      else
         # Enviar-lo
         scp -q $DIR_LOG/${t}_$data.log $ELK_SERVER
         if  [ $? -ne 0 ]
         then
           echo "error enviant a $ELK_SERVER"
         else
           # Eliminar .err
           rm $DIR_LOG/${t}_$data.err
           # Comprimir
           gzip $DIR_LOG/${t}_$data.log
           # Moure
           mv $DIR_LOG/${t}_$data.log.gz $DIR_HISTORIC
		   echo "Fitxer $DIR_LOG/${t}_$data.log enviat, i arxivat a $DIR_HISTORIC/${t}_$data.log.gz"
         fi
      fi
    else
	   echo "No s'ha generat fitxer per $t perque ja existeix en $DIR_HISTORIC/${t}_$data.log.gz"
	fi
  done
