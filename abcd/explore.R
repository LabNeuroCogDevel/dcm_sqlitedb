library(sqldf)
library(dplyr)

# get date time from mr date and time
# 20161130 102920.052500
datetime <- function(d,x) lubridate::fast_strptime(paste0(d,substr(x,1,6)),'%Y%m%d%H%M%S') %>% as.POSIXct 
showtime <- function(x)   strftime(x,'%H:%M',tz="UTC")

db <- src_sqlite('db.sqlite3')
#d<-tbl(db,sql("select scanid,ndcm,seqno,Name,Date from mrinfo where Name like '%fMRI_rest%'"))
m<-as.data.frame(tbl(db,sql("select v.id,Name,mot.value as noMotion,er.value as extrisk, mint,maxt,finaldur,Date,Time,ageatscan as age,Sex,Operator,seqno,ndcm,RT from mrinfo m join visit v on m.scanid=v.scanid left join motion mot on mot.id=v.id left join extrisk er on er.id=v.id")))

m$dt <- datetime(m$Date,m$Time)

smry <- 
  m %>% 
  group_by(id,Date,Operator,Sex,noMotion,age,extrisk) %>% 
  arrange(dt) %>%
  summarise(
    startTime=min(dt),
    endTime=last(dt)+last(finaldur),
    durMin=round((endTime-startTime)/60,2),
    nAllSeq=n(),
    nTask=length(which( Name %in% c('ABCD_fMRI_task_Emotional_n-back','ABCD_fMRI_task_Monetary_Incentive','ABCD_fMRI_task_Stop'))),
    nTaskComp=length(which(
      (Name=='ABCD_fMRI_task_Emotional_n-back'   & ndcm==370) |
      (Name=='ABCD_fMRI_task_Monetary_Incentive' & ndcm==411) |
      (Name=='ABCD_fMRI_task_Stop'               & ndcm==445)
    )),
    nRestComp=length(which(ndcm==383 & grepl('ABCD_fMRI_rest',Name))),
    nRest=length(which(grepl('ABCD_fMRI_rest',Name))),
    nRestDcm=sum(ndcm[grepl('ABCD_fMRI_rest',Name)])
  ) %>% 
  mutate(
    startTime=showtime(startTime),
    endTime=showtime( endTime)
  )

write.table(smry,file='out/summary.csv',row.names=F,sep=",")

p <- ggplot(smry) + 
  aes(
    x=noMotion,
    y=as.factor(extrisk),
    color=age,
    size=durMin
  ) +
  #geom_jitter(width=.2,height=.2)+
  geom_point() +
  theme_bw()
print(p)

ggsave('out/summary:age_dur_extrisk_nrest.png',p)
