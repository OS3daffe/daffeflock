#! /bin/bash

# SERVERS:
# 145.100.108.226
# 145.100.108.227
# 54.170.150.234
# 54.166.35.73
# 50.18.6.49
# 54.251.233.108

# DATA TRANSFER ROUGHLY:
# empty   = 0 entries of 4K
# 100 MiB = 25K entries of 4K
# 1 GiB   = 250K entries of 4K
# 10 GiB  = 2.5M entries of 4K

LOG=all.txt
URL=http://145.100.108.227:8080/count
MONGODB=145.100.108.227/daffe
MONGODB_COUNT_QUERY="db.dummy.count()"
MONGODB_BYTES_QUERY="db.dummy.stats().size"

# Trap kill
trap 'pkill -f mongotime.sh' EXIT

# Open log file
echo -e "\nSTARTING DAFFE TESTS AT: $(date)\n" > $LOG
echo -e "NOTES:\n- nsec values is database downtime\n- min/sec value is migration duration\n- Application starts and ends at DAFFE1\n" >> $LOG

# Start initial deployment to first server in Amsterdam
flocker-deploy daffeflock-deployment1.yml daffeflock-application.yml

# Loop data increments (approximations!!!)
for records in 2 20000 200000 2000000; do
  # Insert the new records
  echo -e "\n----------------------------------------\n DATA INCREMENT OF: $records records (4K)\n" >> $LOG
  (time mongo 145.100.108.226/daffe --quiet --eval "for (var i = 1; i <= $records; i++) {    db.dummy.insert( {y:'Examine she brother prudent add day ham. Far stairs now coming bed oppose hunted become his. You zealously departure had procuring suspicion. Books whose front would purse if be do decay. Quitting you way formerly disposed perceive ladyship are. Common turned boy direct and yet. Abilities forfeited situation extremely my to he resembled. Old had conviction discretion understood put principles you. Match means keeps round one her quick. She forming two comfort invited. Yet she income effect edward. Entire desire way design few. Mrs sentiments led solicitude estimating friendship fat. Meant those event is weeks state it to or. Boy but has folly charm there its. Its fact ten spot drew. Old unsatiable our now but considered travelling impression. In excuse hardly summer in basket misery. By rent an part need. At wrong of of water those linen. Needed oppose seemed how all. Very mrs shed shew gave you. Oh shutters do removing reserved wandered an. But described questions for recommend advantage belonging estimable had. Pianoforte reasonable as so am inhabiting. Chatty design remark and his abroad figure but its. Concerns greatest margaret him absolute entrance nay. Door neat week do find past he. Be no surprise he honoured indulged. Unpacked endeavor six steepest had husbands her. Painted no or affixed it so civilly. Exposed neither pressed so cottage as proceed at offices. Nay they gone sir game four. Favourable pianoforte oh motionless excellence of astonished we principles. Warrant present garrets limited cordial in inquiry to. Supported me sweetness behaviour shameless excellent so arranging. Sociable on as carriage my position weddings raillery consider. Peculiar trifling absolute and wandered vicinity property yet. The and collecting motionless difficulty son. His hearing staying ten colonel met. Sex drew six easy four dear cold deny. Moderate children at of outweigh it. Unsatiable it considered invitation he travelling insensible. Consulted admitting oh mr up as described acuteness propriety moonlight. Am terminated it excellence invitation projection as. She graceful shy believed distance use nay. Lively is people so basket ladies window expect. Supply as so period it enough income he genius. Themselves acceptance bed sympathize get dissimilar way admiration son. Design for are edward regret met lovers. This are calm case roof and. Greatly hearted has who believe. Drift allow green son walls years for blush. Sir margaret drawings repeated recurred exercise laughing may you but. Do repeated whatever to welcomed absolute no. Fat surprise although outlived and informed shy dissuade property. Musical by me through he drawing savings an. No we stand avoid decay heard mr. Common so wicket appear to sudden worthy on. Shade of offer ye whole stood hoped. Sportsman delighted improving dashwoods gay instantly happiness six. Ham now amounted absolute not mistaken way pleasant whatever. At an these still no dried folly stood thing. Rapid it on hours hills it seven years. If polite he active county in spirit an. Mrs ham intention promotion engrossed assurance defective. Confined so graceful building opinions whatever trifling in. Insisted out differed ham man endeavor expenses. At on he total their he songs. Related compact effects is on settled do. It prepare is ye nothing blushes up brought. Or as gravity pasture limited evening on. Wicket around beauty say she. Frankness resembled say not new smallness you discovery. Noisier ferrars yet shyness weather ten colonel. Too him himself engaged husband pursuit musical. Man age but him determine consisted therefore. Dinner to beyond regret wished an branch he. Remain bed but expect suffer little repair. Is he staying arrival address earnest. To preference considered it themselves inquietude collecting estimating. View park for why gay knew face. Next than near to four so hand. Times so do he downs me would. Witty abode party her found quiet law. They door four bed fail now have.', x :i } ) }") >> $LOG 2>&1
  echo -e "----------------------------------------\n" >> $LOG

  # Go around the world!
  for deployment in daffeflock-deployment2.yml daffeflock-deployment3.yml daffeflock-deployment4.yml daffeflock-deployment5.yml daffeflock-deployment6.yml daffeflock-deployment1.yml; do
    # Start by running timing script on MongoDB
    echo -e "----------------------------------------\n DEPLOYMENT: $deployment\n----------------------------------------" >> $LOG
    echo -e "MONGODB MIGRATION TIMINGS:" >> $LOG
    ./mongotime.sh >> $LOG &

    # Redeploy application after a small pause (note that first deployment includes these seconds in MongoDB downtime)
    sleep 5
    echo "Starting deployment: $deployment ..."
    (time flocker-deploy $deployment daffeflock-application.yml) >> $LOG 2>&1
    echo "Deployment $deployment done."

    # Stop timing script after a longer pause (allowin proper reconnect in any case)
    sleep 30
    pkill -f mongotime.sh > /dev/null 2>&1

    # Log the record count from MongoDB
    sleep 5
    echo -n -e "\nMONGODB BYTES DIRECT: " >> $LOG
    mongo $MONGODB --quiet --eval $MONGODB_BYTES_QUERY >> $LOG
    echo -n -e "MONGODB COUNT DIRECT: " >> $LOG
    mongo $MONGODB --quiet --eval $MONGODB_COUNT_QUERY >> $LOG
    echo -n -e "MONGODB COUNT HTTP:   " >> $LOG
    wget -O - -q $URL >> $LOG
    echo -n -e "\nMONGODB TIMES HTTP:\n" >> $LOG
    curl -w "@curl-format.txt" -s $URL >> $LOG 2>&1
    echo -e "-----\n" >> $LOG
  done

done

# Finish log file
echo -e "DAFFE TESTS DONE AT: $(date)\n" >> $LOG

