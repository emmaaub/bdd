/**create table EFFORT_ANALYSE (
   ID_ANALYSE_EFFORT    NUMBER                not null,
   ID_PATIENT           NUMBER                not null,
   DATE_ANALYSE_EFFORT  DATE                  not null,
   DATE_PROCHAINE_ANALYSE_EFFORT DATE,
   COMPLEMENTAIRE_EFFORT NUMBER                not null
      constraint CKC_COMPLEMENTAIRE_EF_EFFORT_A check (COMPLEMENTAIRE_EFFORT in (0,1)),
   RESULTAT_RYTHME_CARDIAQUE_AVANT NUMBER,
   RESULTAT_RYTHME_CARDIAQUE_APRES NUMBER,
   RESULTAT_RYTHME_CARDIAQUE_UNEM NUMBER,
   constraint PK_EFFORT_ANALYSE primary key (ID_ANALYSE_EFFORT)
)
/*/

create or replace trigger prediction_date_prochaine_analyse_effort before insert or update on EFFORT_ANALYSE
for each row
declare
    POBESITE NUMBER;
    PHYPERTENSION NUMBER;
    PMENOPAUSE NUMBER;
    DATE_PRO_ANALYSE date;
begin
     SELECT OBESITE INTO POBESITE FROM Patient WHERE Id_Patient = :new.ID_Patient;
     SELECT HYPERTENSION INTO PHYPERTENSION FROM Patient WHERE Id_Patient = :new.ID_Patient;
     SELECT MENOPAUSE INTO PMENOPAUSE FROM Patient WHERE Id_Patient = :new.ID_Patient;

    IF :new.COMPLEMENTAIRE_EFFORT = 1 then 
        IF POBESITE = 1 or PHYPERTENSION = 1 or PMENOPAUSE = 1 then
            :new.DATE_PROCHAINE_ANALYSE_EFFORT:= :new.DATE_ANALYSE_EFFORT;
        else 
            :new.DATE_PROCHAINE_ANALYSE_EFFORT:= :new.DATE_ANALYSE_EFFORT + 1;
        end if; 
    else 
        IF POBESITE = 1 or PHYPERTENSION = 1 or PMENOPAUSE = 1 then
            :new.DATE_PROCHAINE_ANALYSE_EFFORT:= :new.DATE_ANALYSE_EFFORT + 2;
        else 
            :NEW.DATE_PROCHAINE_ANALYSE_EFFORT := :new.DATE_ANALYSE_EFFORT + 3 ;
         end if;    
    end if;
end ;
/

CREATE OR REPLACE PROCEDURE Peuplement_Analyse_Effort(
   PID_PATIENT NUMBER,
   PDATE_ANALYSE_EFFORT DATE,
   PCOMPLEMENTAIRE_EFFORT NUMBER,
   PRESULTAT_AVANT_BPM NUMBER,
   PRESULTAT_APRES_BPM NUMBER,
   PRESULTAT_UNEMIN_BPM NUMBER)
AS
    id_pat int;
BEGIN
    SELECT Id_Patient INTO id_pat FROM Patient WHERE Id_Patient = PID_PATIENT;
    
    INSERT INTO Effort_Analyse (ID_PATIENT, Date_Analyse_effort, Complementaire_effort, RESULTAT_AVANT_BPM, RESULTAT_APRES_BPM, RESULTAT_UNEMIN_BPM) 
    VALUES (id_pat, PDATE_ANALYSE_EFFORT, PCOMPLEMENTAIRE_EFFORT, PRESULTAT_AVANT_BPM, PRESULTAT_APRES_BPM, PRESULTAT_UNEMIN_BPM);
    
END Peuplement_Analyse_Effort;
/

ALTER TRIGGER COMPOUNDINSERTTRIGGER_EFFORT_A DISABLE;
ALTER TRIGGER COMPOUNDDELETETRIGGER_EFFORT_A DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_EFFORT_A DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_EFFORT_A DISABLE;
DELETE FROM EFFORT_ANALYSE;

CALL Peuplement_Analyse_Effort (46, SYSDATE, 0, 100, 100, 100);
/

CREATE OR REPLACE PROCEDURE TestAutoIncrementation_Effort_Analyse deterministic AS
    vpremiere_id int;
    vseconde_id int;
BEGIN
    commit;
    INSERT INTO EFFORT_ANALYSE(ID_PATIENT, Date_Analyse_effort, Complementaire_effort, RESULTAT_AVANT_BPM, RESULTAT_APRES_BPM, RESULTAT_UNEMIN_BPM) 
    VALUES (1, SYSDATE, 0, 100, 100, 100);
    INSERT INTO EFFORT_ANALYSE(ID_PATIENT, Date_Analyse_effort, Complementaire_effort, RESULTAT_AVANT_BPM, RESULTAT_APRES_BPM, RESULTAT_UNEMIN_BPM) 
    VALUES (2, SYSDATE, 0, 100, 100, 100);
    select ID_ANALYSE_EFFORT into vpremiere_id from EFFORT_ANALYSE where ID_PATIENT = 1;
    select ID_ANALYSE_EFFORT into vseconde_id from EFFORT_ANALYSE where ID_PATIENT = 2;
    
    if vpremiere_id = 1 and vseconde_id = 2 then
        rollback; 
        insert into TESTS_BDD (Nom_Test, Resultat_Test) values('TestAutoIncrementation_Effort_Analyse', 'Test réussit') ;
        commit ; 
    else
        rollback;
        insert into TESTS_BDD (Nom_Test, Resultat_Test) values('TestAutoIncrementation_Effort_Analyse', 'défaillance') ;
        commit;
     end if;
end;
/

call TestAutoIncrementation_Effort_Analyse();
 
CREATE OR REPLACE PROCEDURE Test_prediction_prochaine_date_Effort_Analyse deterministic AS
    vpremiere_date_analyse date;
    vseconde_date_analyse date;
    vtrois_date_analyse date;
    vquatre_date_analyse date;
    v_id_arc number;
    v_num_adeli number;
    v_id_patient1 number;
    v_id_patient2 number;
    v_id_analyse_effort1 number;
    v_id_analyse_effort2 number;
    v_id_analyse_effort3 number;
    v_id_analyse_effort4 number;
    nb1 int;
    nb2 int;
    nb3 int;
    nb4 int;
BEGIN
    INSERT INTO ARC (Nom_ARC, Prenom_ARC)
    VALUES ('TestEffort', 'Mariline');
    select ID_ARC into v_id_arc from ARC where Nom_ARC = 'TestEffort';

    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin)
    VALUES (123456789, v_id_arc, 'generaliste', 45, 'Pineau', 'Marie');
    select Num_ADELI_Medecin into v_num_adeli from Medecin where Nom_Medecin = 'Pineau';

    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli, 'Tetu', 'Jean', 'M', TO_DATE('22/03/2000', 'DD-MM-YYYY'), 2122345678912, 0, 1, 1, 0, 0, 'VV', 1);
    select id_patient into v_id_patient1 from Patient where Nom_Patient = 'Tetu';
    
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli, 'Menu', 'Juliette', 'F', TO_DATE('22/03/2000', 'DD-MM-YYYY'), 2122345678912, 1, 1, 1, 0, 0, 'VV', 1);
    select  id_patient into v_id_patient2 from Patient where Nom_Patient = 'Menu';
    
    INSERT INTO EFFORT_ANALYSE(ID_PATIENT, Date_Analyse_effort, Complementaire_effort, RESULTAT_AVANT_BPM, RESULTAT_APRES_BPM, RESULTAT_UNEMIN_BPM) 
    VALUES (v_id_patient1, SYSDATE, 0, 100, 100, 100);
    select count(*) into nb1 from EFFORT_ANALYSE where id_patient = v_id_patient1;
    if nb1>0 then
        select id_analyse_effort into v_id_analyse_effort1 from (select id_analyse_effort from EFFORT_ANALYSE where id_patient = v_id_patient1 
        order by id_analyse_effort)
        where rownum = 1;
    end if;
    
    INSERT INTO EFFORT_ANALYSE(ID_PATIENT, Date_Analyse_effort, Complementaire_effort, RESULTAT_AVANT_BPM, RESULTAT_APRES_BPM, RESULTAT_UNEMIN_BPM) 
    VALUES (v_id_patient1, SYSDATE, 1, 100, 100, 100);
    select count(*) into nb2 from EFFORT_ANALYSE where id_patient = v_id_patient1;
    if nb2>0 then
        SELECT id_analyse_effort INTO v_id_analyse_effort2 
        FROM (
            SELECT id_analyse_effort, ROW_NUMBER() OVER (ORDER BY id_analyse_effort) AS rn
            FROM EFFORT_ANALYSE 
            WHERE id_patient = v_id_patient1
        ) 
        WHERE rn = 2;
    end if;
    
    INSERT INTO EFFORT_ANALYSE(ID_PATIENT, Date_Analyse_effort, Complementaire_effort, RESULTAT_AVANT_BPM, RESULTAT_APRES_BPM, RESULTAT_UNEMIN_BPM) 
    VALUES (v_id_patient2, SYSDATE, 0, 100, 100, 100);
    select count(*) into nb3 from EFFORT_ANALYSE where id_patient = v_id_patient2;
    if nb3>0 then
        SELECT id_analyse_effort INTO v_id_analyse_effort3 
        FROM (
            SELECT id_analyse_effort, ROW_NUMBER() OVER (ORDER BY id_analyse_effort) AS rn
            FROM EFFORT_ANALYSE 
            WHERE id_patient = v_id_patient2
        ) 
        WHERE rn = 1;
    end if;
    
    INSERT INTO EFFORT_ANALYSE(ID_PATIENT, Date_Analyse_effort, Complementaire_effort, RESULTAT_AVANT_BPM, RESULTAT_APRES_BPM, RESULTAT_UNEMIN_BPM) 
    VALUES (v_id_patient2, SYSDATE, 1, 100, 100, 100);
    select count(*) into nb4 from EFFORT_ANALYSE where id_patient = v_id_patient2;
    if nb4>0 then
        SELECT id_analyse_effort INTO v_id_analyse_effort4 
        FROM (
            SELECT id_analyse_effort, ROW_NUMBER() OVER (ORDER BY id_analyse_effort) AS rn
            FROM EFFORT_ANALYSE 
            WHERE id_patient = v_id_patient2
        ) 
        WHERE rn = 2;
    end if;
    
    
    select DATE_PROCHAINE_ANALYSE_EFFORT into vpremiere_date_analyse from EFFORT_ANALYSE where id_analyse_effort = v_id_analyse_effort1;
    select DATE_PROCHAINE_ANALYSE_EFFORT into vseconde_date_analyse from EFFORT_ANALYSE where id_analyse_effort = v_id_analyse_effort2;
    select DATE_PROCHAINE_ANALYSE_EFFORT into vtrois_date_analyse from EFFORT_ANALYSE where id_analyse_effort = v_id_analyse_effort3;
    select DATE_PROCHAINE_ANALYSE_EFFORT into vquatre_date_analyse from EFFORT_ANALYSE where id_analyse_effort = v_id_analyse_effort4;
    
    if vpremiere_date_analyse = SYSDATE+3 and vseconde_date_analyse = SYSDATE+1 and vtrois_date_analyse = SYSDATE+2 and vquatre_date_analyse = SYSDATE then
        rollback; 
        insert into TESTS_BDD (Nom_Test, Resultat_Test) values('Test_prediction_prochaine_date_Effort_Analyse', 'Test réussi') ;
        commit ; 
    elsif vpremiere_date_analyse != SYSDATE+3 then 
        rollback; 
        insert into TESTS_BDD (Nom_Test, Resultat_Test) values('Test_prediction_prochaine_date_Effort_Analyse', 'Echec avec test normal et patient classique') ;
        commit ; 
    elsif vseconde_date_analyse != SYSDATE+1 then 
        rollback; 
        insert into TESTS_BDD (Nom_Test, Resultat_Test) values('Test_prediction_prochaine_date_Effort_Analyse', 'Echec avec test complémentaire et patient classique') ;
        commit ; 
    elsif vtrois_date_analyse != SYSDATE+2 then 
        rollback; 
        insert into TESTS_BDD (Nom_Test, Resultat_Test) values('Test_prediction_prochaine_date_Effort_Analyse', 'Echec avec test normal et patient probleme') ;
        commit ; 
    elsif vquatre_date_analyse != SYSDATE then
        rollback;
        insert into TESTS_BDD (Nom_Test, Resultat_Test) values('Test_prediction_prochaine_date_Effort_Analyse', 'Echec avec test complementaire et patient probleme') ;
        commit;
     end if;
end;
/

call Test_prediction_prochaine_date_Effort_Analyse();


--drop TestAutoIncrementation_Effort_Analyse();

--EXCEPTION c'est pour tester les contraintes !!!
    --WHEN others THEN

--TO_DATE('22/03/2024', 'DD-MM-YYYY')