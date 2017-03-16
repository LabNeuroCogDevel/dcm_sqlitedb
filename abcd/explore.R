library(sqldf)
library(dplyr)
db <- src_sqlite('db.sqlite3')
#d<-tbl(db,sql("select scanid,ndcm,seqno,Name,Date from mrinfo where Name like '%fMRI_rest%'"))
m<-as.data.frame(tbl(db,sql("select v.id,mot.value as motion,mint,maxt,finaldur,Date,ageatscan,Sex,Operator,seqno,ndcm,RT from mrinfo m join visit v on m.scanid=v.scanid left join motion mot on mot.id=v.id where Name like '%fMRI_rest%'")))


restsum <- m %>% group_by(id,Date,Operator,Sex,motion,ageatscan) %>% summarise(nDcm383=length(ndcm==383),nAnyRest=n(),total=sum(ndcm))
write.table(restsum,file='restsummary.csv',row.names=F,sep=",")
