CREATE TABLE subj (
    id          char(20),
    sex         char(1),
    dob         timestamp
);

CREATE TABLE visit (
    id          char(20),      --  link to subj
    scanid      char(25),
    ageatscan   float,
    timepoint   int,
    mint        numeric,
    maxt        numeric,
    finaldur    numeric,
    finalprot   text
);

create table analysis (
     analysis  varchar(20),
     scanid    char(25),
     protocol  text,
     runnum    int ,
     dir       text,
     finalfile text,
     rawdir    text -- link to mrinfo dir
);

create table motion (
     id     char(20),
     title  text,
     value  numeric
);
create table extrisk (
     id     char(20),
     value  numeric
);

create TABLE mrinfo (
    
    scanid    char(25),
    dir       text,
    seqno     int,
    ndcm      int,
    
    id         text,
    Birthdate  text,
    Sex text,
    Date text,
    Time text,
    Name text,
    Operator text,
    Spacing text,
    PhaseEncodingDirection text,
    Thing1  text,
    RT float,
    ET float,
    Flip float,
    nRows float,
    nColumns float,
    PhaseEncodingSteps float,
    Thing2 text,
    Software text,
    Matrix text
);
