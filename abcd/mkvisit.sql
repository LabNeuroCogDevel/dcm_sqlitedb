--delete from visit;

insert into visit 
 select
  d.scanid as id,
  d.scanid,
  round( (julianday( date(substr(d,1,4)||'-'||substr(d,5,2)||'-'||substr(d,7,2))) - 
   julianday(date(substr(b,1,4)||'-'||substr(b,5,2)||'-'||substr(b,7,2))  ) 
   )/365.25,2) as age,
   1 as timepoint,
   mint,
   maxt as maxstartt,
   ndcm*RT/1000 as finaldur,
   Name as finalproto

 from 
   (select scanid,max(Date) as d, min(Birthdate) as b,  min(Time) as mint, max(Time) as maxt from mrinfo group by scanid) as d
 join 
   mrinfo m on d.maxt=m.Time and d.scanid = m.scanid;

-- select ndcm*RT/1000 as lastdur from (select scanid, max(Time) as Time from mrinfo group by scanid) as d join mrinfo m on d.Time=m.Time and d.scanid=d.scanid;
 
