#!/bin/bash
###############################################################################
#  monit_neteges_drives_acsls1_per_elk.sh
#
#  Script que parseja els logs de les neteges de drives de l'ACSL, es queda
#  amb els que són d'ahir i els envia a la  maquina on s'executa logstash
#  per carregar-ho a elk.
#
#  NOTA: Requereix que hi hagi una clau ssh de l'usuari del ELK_SERVER en 
#        l'usuari en que s'executa aquest script 
#
#  Parametres:
#    $1: Dia a generar logs en format "yyyy-mm-dd"
#    $2, $3: Tipus de logs a generar: Valors valids: "requests events". Poden ser
#            un o dos valors
###############################################################################
DIR_BASE="/opt/csw/libexec/nagios-plugins"
FITXER_BASE="monit_neteges_drives.sh.historic"
FITXER_PARSEJAT="monit_neteges_drives_acsls1_per_elk.sh.historic"
ELK_SERVER="logstash@elk.dtvc.local"
### DIR_ELK_SERVER="/var/data/logstash/prova"
DIR_ELK_SERVER="/var/data/logstash/acsls"

##################
# Cos del script #
##################

# Adaptació nomenclatura drives a la de DIVA
#  p.ex. canviem: "2014-04-09.06:56:21; 1, 2, 1,15"
#            per: "2014-04-09.06:56:21;(1, 2, 1, 15);SL8500-CEI"
#  p.ex. canviem: "2014-04-09.06:56:21; 2, 2, 1,15"
#            per: "2014-04-09.06:56:21;(2, 2, 1, 15);SL8500-CPA"
cat ${DIR_BASE}/${FITXER_BASE} | grep "; 1" | sed 's/; 1/;(1/' | tr -d ' ' | sed 's/,/, /g' | sed 's/$/);SL8500-CEI/' > ${DIR_BASE}/${FITXER_PARSEJAT}
cat ${DIR_BASE}/${FITXER_BASE} | grep "; 2" | sed 's/; 2/;(2/' | tr -d ' ' | sed 's/,/, /g' | sed 's/$/);SL8500-CPA/' >> ${DIR_BASE}/${FITXER_PARSEJAT}

# Parseig logs d'ahir
DATA_AVUI=`date +%Y-%m-%d`
cat ${DIR_BASE}/${FITXER_PARSEJAT} | grep `TZ=GMT+24 date +%Y-%m-%d` > ${DIR_BASE}/${FITXER_PARSEJAT}_${DATA_AVUI}.log

# Enviem logs al ELK_SERVER
scp -q ${DIR_BASE}/${FITXER_PARSEJAT}_${DATA_AVUI}.log ${ELK_SERVER}:${DIR_ELK_SERVER}

# Esborrem logs d'ahir
rm ${DIR_BASE}/${FITXER_PARSEJAT}_${DATA_AVUI}.log


######################################################################################################
# Enviem logs inicials al ELK_SERVER
### scp -q ${DIR_BASE}/${FITXER_PARSEJAT} ${ELK_SERVER}:${DIR_ELK_SERVER}
