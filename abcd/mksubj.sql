insert into subj 
select id, sex, date(substr(b,1,4)||'-'||substr(b,5,2)||'-'||substr(b,7,2)) as dob
 from (
     select scanid as id, min(Sex) as sex, min(Birthdate) as b from mrinfo group by scanid
    );
