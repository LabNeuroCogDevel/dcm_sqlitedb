library(sqldf)
library(dplyr)

# get date time from mr date and time
# 20161130 102920.052500
datetime <- function(d,x) lubridate::fast_strptime(paste0(d,substr(x,1,6)),'%Y%m%d%H%M%S') %>% as.POSIXct 
showtime <- function(x)   strftime(x,'%H:%M',tz="UTC")

db <- src_sqlite('db.sqlite3')
#d<-tbl(db,sql("select scanid,ndcm,seqno,Name,Date from mrinfo where Name like '%fMRI_rest%'"))
m<-as.data.frame(tbl(db,sql("select v.id,Name,mot.value as motion,er.value as extrisk, mint,maxt,finaldur,Date,Time,ageatscan as age,Sex,Operator,seqno,ndcm,RT from mrinfo m join visit v on m.scanid=v.scanid left join motion mot on mot.id=v.id left join extrisk er on er.id=v.id")))

m$dt <- datetime(m$Date,m$Time)

smry <- 
  m %>% 
  group_by(id,Date,Operator,Sex,motion,age,extrisk) %>% 
  arrange(dt) %>%
  summarise(
    firstSeqStartT=min(dt),
    lastSeqEndT=last(dt)+last(finaldur),
    durMin=(lastSeqEndT-firstSeqStartT)/60,
    nAllSeq=n(),
    nRestSeqDcm383=length(which(ndcm==383 & grepl('ABCD_fMRI_rest',Name))),
    nRest=length(which(grepl('ABCD_fMRI_rest',Name))),
    nRestDcm=sum(ndcm[grepl('ABCD_fMRI_rest',Name)])
  ) %>% 
  mutate(
    firstSeqStartT=showtime(firstSeqStartT),
    lastSeqEndT=showtime( lastSeqEndT)
  )

write.table(smry,file='out/summary.csv',row.names=F,sep=",")

p <- ggplot(smry) + 
  aes(
    y=nRestSeqDcm383,
    x=as.factor(extrisk),
    color=age,
    size=durMin
  ) +
  geom_jitter(width=.2,height=.2)+
  theme_bw()
print(p)

ggsave('out/summary:age_dur_extrisk_nrest.png',p)
