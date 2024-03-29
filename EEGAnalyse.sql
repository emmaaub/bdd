/*==============================================================*/
/* Table : EEG_ANALYSE                                          */
/*==============================================================*/
drop table EEG_ANALYSE cascade constraints;
create table EEG_ANALYSE (
   ID_ANALYSE_EEG       NUMBER,                --not null,
   ID_PATIENT           NUMBER,                --not null,
   DATE_ANALYSE_EEG     DATE ,                 --not null,
   DATE_PROCHAINE_ANALYSE_EEG DATE,
   COMPLEMENTAIRE_EEG   NUMBER                --not null
      constraint CKC_COMPLEMENTAIRE_EE_EEG_ANAL check (COMPLEMENTAIRE_EEG in (0,1)),
   RESULTAT_EEG         NUMBER
      constraint VALUES_EEG check (RESULTAT_EEG>0 AND RESULTAT_EEG<9),    
      constraint PK_EEG_ANALYSE primary key (ID_ANALYSE_EEG)
)
/
/*==============================================================*/
/* Trigger : Génération d'ID                                    */
/*==============================================================*/
drop sequence S1;
create sequence S1;

create or replace trigger ValeurID
before insert on EEG_ANALYSE for each row
begin
    select S1.nextval into :new.ID_ANALYSE_EEG from dual;
end;
/

/*==============================================================*/
/* Trigger : PROGRAMMATION prochaine analyse == faire un trigger composé */
/*==============================================================*/
create or replace trigger nextAnalyse
after insert on EEG_ANALYSE
for each row
declare
    newDate date;
    previousResult number;
    complementaire number;
    currentDate date;
begin
    currentDate := TRUNC(SYSDATE);
    -- Récupération du résultat de l'EEG à l'ID précédent
    select RESULTAT_EEG into previousResult
    from EEG_ANALYSE
    where ID_ANALYSE_EEG  = :new.ID_ANALYSE_EEG - 1; 
    
    --Récupération du statut complémentaire ou non de l'examen
    select COMPLEMENTAIRE_EEG into complementaire
    from EEG_ANALYSE
    where ID_ANALYSE_EEG  = :new.ID_ANALYSE_EEG; 
    
    
    if :new.RESULTAT_EEG < 3 AND previousResult < 3 then
        -- Calculer la date du prochain examen (DATE_ANALYSE_EEG + 1 jours)
        newDate := currentDate + 1;
        update EEG_ANALYSE
        set DATE_PROCHAINE_ANALYSE_EEG = newDate,
        COMPLEMENTAIRE_EEG = 1
        where ID_ANALYSE_EEG = :new.ID_ANALYSE_EEG; 
        
    elsif complementaire=0 then
        -- Calculer la date du prochain examen (DATE_ANALYSE_EEG + 6 jours)
         newDate := :new.DATE_ANALYSE_EEG + 6;
         update EEG_ANALYSE
        set DATE_PROCHAINE_ANALYSE_EEG = newDate,
        COMPLEMENTAIRE_EEG = 0
        where ID_ANALYSE_EEG = :new.ID_ANALYSE_EEG; 

    end if;
    
end;
/

/*==============================================================*/
/* Index : ANALYSE_TEST_EEG_FK                                  */
/*==============================================================*/
create index ANALYSE_TEST_EEG_FK on EEG_ANALYSE (
   ID_PATIENT ASC
)
/
/*==============================================================*/
/* Procédure : Peuplement                                       */
/*==============================================================*/
create or replace procedure Peupler(n in number) deterministic as
    VDate date;
    VResultat number;
    begin
        for i in 1..n loop
        select
        TRUNC(SYSDATE),
        round(8*DBMS_Random.Value())
    into
        VDate,
        VResultat
    from dual;
        insert into EEG_ANALYSE values (
        null,
        null,
        VDate,
        null,
        null,
        Vresultat
        );
    end loop;
end;
/
call Peupler(100);
--select * from EEG_ANALYSE;
commit;
