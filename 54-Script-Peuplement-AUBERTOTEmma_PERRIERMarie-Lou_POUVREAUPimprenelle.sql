ALTER TRIGGER COMPOUNDINSERTTRIGGER_CENTRE_E DISABLE;
ALTER TRIGGER COMPOUNDINSERTTRIGGER_ARC DISABLE;
ALTER TRIGGER COMPOUNDINSERTTRIGGER_MEDECIN DISABLE;
ALTER TRIGGER COMPOUNDINSERTTRIGGER_PATIENT DISABLE;
ALTER TRIGGER COMPOUNDINSERTTRIGGER_SANG_ANA DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_SANG_ANA DISABLE;
ALTER TRIGGER COMPOUNDINSERTTRIGGER_PCR_COVI DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_PCR_COVI DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_PATIENT DISABLE;
ALTER TRIGGER COMPOUNDINSERTTRIGGER_EFFORT_A DISABLE;
ALTER TRIGGER COMPOUNDDELETETRIGGER_EFFORT_A DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_EFFORT_A DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_EFFORT_A DISABLE;
ALTER TRIGGER COMPOUNDINSERTTRIGGER_VISITE_Q DISABLE;

alter table PCR_Covid_Analyse add constraint Nom_Resultats_PCR_Covid
check (Resultat_PCR_Covid in ('Negatif','Variant alpha detecte','Variant delta detecte','Variant omega detecte'));

ALTER TABLE Intervalles_resultats_sang_ana add constraint Nom_Type_Analyse
check (Type_Analyse in ('Cholesterol','Glycemie','Plaquettes','4','5','6'));


--######################################################################################################################
--######################### PEUPLEMENT CENTRE ESSAIS CLINIQUE ######################################################################
--######################################################################################################################

CREATE OR REPLACE PROCEDURE Peuplement_Centre
AS
BEGIN
    INSERT INTO CENTRE_EC (NOM_CENTRE) VALUES ('Maragolles');
    COMMIT;
END Peuplement_Centre;
/

--##################################################################################################################################################################################
--################### PEUPLEMENT ARC ##########################################################################################################################################################
--##################################################################################################################################################################################

CREATE OR REPLACE PROCEDURE Peuplement_ARC(
    PnomARC VARCHAR2,
    PprenomARC VARCHAR2
)
IS
    pidcentre INT;
BEGIN
    -- Sélectionner l'ID du centre
    SELECT Id_centre_ec INTO pidcentre FROM centre_ec WHERE Id_centre_ec = 1;
    
        -- Insérer dans la table ARC
        INSERT INTO ARC (ID_CENTRE_EC, Nom_ARC, Prenom_ARC)
        VALUES (pidcentre, PnomARC, PprenomARC);
        COMMIT;
END Peuplement_ARC;
/

--##########################################################################################################################################################################################################
--################### PEUPLEMENT MEDECIN ###########################################################################################################################################################################
--##########################################################################################################################################################################################################

CREATE OR REPLACE PROCEDURE Peuplement_Medecin(
PnumADELI int,
Pspe_med varchar2,
Pcohorte int,
PNomM varchar2,
PPrenomM varchar2)
AS
    PIDARC int;
    pidcentre INT;
BEGIN

    SELECT Id_centre_ec INTO pidcentre FROM centre_ec WHERE Id_centre_ec = 1;
    
    SELECT Id_ARC INTO PIDARC FROM ARC WHERE Id_ARC = 1;
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, ID_CENTRE_EC,Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin)
    VALUES (PnumADELI, PIDARC, pidcentre,Pspe_med, Pcohorte, PNomM, PPrenomM);
    COMMIT;
    
END Peuplement_Medecin;
/

--##########################################################################################################################################################################################################
--################### PEUPLEMENT PATIENT ###########################################################################################################################################################################
--##########################################################################################################################################################################################################

CREATE OR REPLACE PROCEDURE Peuplement_patient (
    Pnom varchar2,
    PPrenom varchar2,
    Psexe varchar2,
    PDDN date,
    PNumSecu int,
    Pmeno int,
    Pgrippe int,
    Pcovid int,
    Phypertension int,
    Pobesite int)
AS
PNumADELIM int;
BEGIN
    SELECT Num_ADELI_Medecin INTO PNumADELIM FROM Medecin WHERE Num_ADELI_Medecin = 123456789;
    
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite)
    VALUES (PNumADELIM, Pnom, PPrenom, Psexe, PDDN, PNumSecu, Pmeno, Pgrippe, Pcovid, Phypertension, Pobesite);
    COMMIT;
END Peuplement_patient;
/

--##########################################################################################################################################################################################################
--################### PEUPLEMENT INTERVALLES SANG ###########################################################################################################################################################################
--##########################################################################################################################################################################################################

CREATE OR REPLACE PROCEDURE Intervalles_resultats_sang_peuplement(
p_type_analyse varchar2,
p_normal_1 integer,
p_normal_2 integer,
p_anormal_1 integer,
p_anormal_2 integer
)
as

begin 
    INSERT INTO Intervalles_Resultats_Sang_Ana VALUES (p_type_analyse, p_normal_1, p_normal_2, p_anormal_1, p_anormal_2);
end Intervalles_resultats_sang_peuplement;
/

--##########################################################################################################################################################################################################
--################### PEUPLEMENT ANALYSE SANG ###########################################################################################################################################################################
--##########################################################################################################################################################################################################
   
CREATE OR REPLACE PROCEDURE Peuplement_Analyse_Sang(
    PIdPatient INT,
    PDate_Analyse DATE,
    Pcomplementaire INT,
    PresChol INT,
    PresGly INT,
    PresPlaq INT,
    Pres4 INT,
    Pres5 INT,
    Pres6 INT
)
AS
 v_id_patient int;
BEGIN
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Id_Patient = PIdPatient;
    
    INSERT INTO Sang_Analyse (Id_Patient, Date_Analyse_Sang, Complementaire_Sang, Resultat_Cholesterol, Resultat_Glycemie, Resultat_Plaquettes, Resultat_4, Resultat_5, Resultat_6) 
    VALUES (v_id_patient, PDate_Analyse, Pcomplementaire, PresChol, PresGly, PresPlaq, Pres4, Pres5, Pres6);
    
    COMMIT;
END Peuplement_Analyse_Sang;
/

--##########################################################################################################################################################################################################
--################### PEUPLEMENT ANALYSE PCR COVID ###########################################################################################################################################################################
--##########################################################################################################################################################################################################

CREATE OR REPLACE PROCEDURE Peuplement_PCR_COVID (
    p_id_patient INT,
    p_date_analyse_pcr_covid DATE,
    p_resultat_pcr_covid VARCHAR2
)
AS
    v_id_patient int;
BEGIN
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Id_Patient = p_id_patient;
    
    INSERT INTO PCR_Covid_Analyse (Id_Patient, Date_Analyse_PCR_Covid, Resultat_PCR_Covid) 
    VALUES (v_id_patient, p_date_analyse_pcr_covid, p_resultat_pcr_covid);
    
    COMMIT;
END Peuplement_PCR_COVID;
/

--##########################################################################################################################################################################################################
--################### PEUPLEMENT ANALYSE EFFORT ###########################################################################################################################################################################
--##########################################################################################################################################################################################################

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

--######################################################################################################################
--######################### PEUPLEMENT AUXILIAIRE ######################################################################
--######################################################################################################################

CREATE OR REPLACE PROCEDURE Peuplement_Auxiliaire (
    p_num_adeli_aux INT,
    p_spe_aux VARCHAR2,
    p_nom_aux VARCHAR2,
    p_prenom_aux VARCHAR2
)
AS
    pidcentre int;
BEGIN
    SELECT Id_centre_ec INTO pidcentre FROM centre_ec WHERE Id_centre_ec = 1;
    
    INSERT INTO AUXILIAIRE (NUM_ADELI_AUXILIAIRE, ID_CENTRE_EC, SPECIALITE_AUXILIAIRE, NOM_AUXILIAIRE, PRENOM_AUXILIAIRE)
    VALUES (p_num_adeli_aux, pidcentre, p_spe_aux, p_nom_aux, p_prenom_aux);

    COMMIT;
END Peuplement_Auxiliaire;
/

--######################################################################################################################
--######################### PEUPLEMENT LOTS ######################################################################
--######################################################################################################################

CREATE OR REPLACE PROCEDURE Peuplement_Lots (
    p_num_lot INT,
    p_type_lot VARCHAR2)
AS
BEGIN
    INSERT INTO LOTS (NUMERO_LOT, TYPE_LOT)
    VALUES (p_num_lot, p_type_lot);
    COMMIT;
END Peuplement_Lots;
/

--##########################################################################################################################################################################################################
--################### PEUPLEMENT VISITE QUOTIDIENNE ###########################################################################################################################################################################
--##########################################################################################################################################################################################################

-----------------------EN COURS ------------------------------------------------------
CREATE OR REPLACE PROCEDURE Peuplement_Visite_Quotidienne (
    p_num_aux INTEGER,
    p_num_lot integer,
   p_id_patient INTEGER,
   p_num_medecin integer,
    p_date_visite date,
    p_poids number, 
    p_pression_arte number, 
    p_rythme_cardiaque number,  
    p_temperature number, 
    p_deb_jour number, 
    p_j_etude number
)
As 
BEGIN
   --FOR i IN 1..3 LOOP 
        --SELECT Num_adeli_auxiliaire INTO p_num_aux FROM Auxiliaire WHERE Num_adeli_auxiliaire = 135790246;
        --SELECT id_patient INTO p_id_patient FROM Patient WHERE Id_Patient = 1;
        --SELECT Num_adeli_medecin INTO p_num_medecin FROM Medecin WHERE Num_adeli_medecin = 123456789;
        --SELECT Numero_lot INTO p_num_lot FROM Lots WHERE Numero_lot = 101;
      -- Insertion des données dans la table
      INSERT INTO VISITE_QUOTIDIENNE (NUM_ADELI_AUXILIAIRE, NUMERO_LOT, ID_PATIENT, NUM_ADELI_MEDECIN, DATE_VISITE_QUOTIDIENNE, POIDS, PRESSION_ARTERIELLE, RYTHME_CARDIAQUE, TEMPERATURE, DEBUT_DE_JOURNEE, JOUR_ETUDE)
      VALUES (p_num_aux, p_num_lot, p_id_patient, p_num_medecin, p_date_visite, p_poids, p_pression_arte, p_rythme_cardiaque,  p_temperature, p_deb_jour, p_j_etude);
   --END LOOP;
   
END Peuplement_Visite_Quotidienne;
/

--##########################################################################################################################################################################################################
--################### PEUPLEMENT ANALYSE EEG ###########################################################################################################################################################################
--##########################################################################################################################################################################################################
create or replace procedure Peupler(n in number) deterministic as
    VPatient number;
    v_random_date DATE; 
    VResultat number;
begin
    for i in 1..n loop
        select
            round(8*DBMS_Random.Value()+1),
            TRUNC(SYSDATE)+DBMS_RANDOM.VALUE(0,-100),
            round(8*DBMS_Random.Value()+1)
        into
            VPatient,
            v_random_date,
            VResultat
        from dual;
        insert into EEG_ANALYSE values (
            null,
            VPatient,
            v_random_date,
            null,
            null,
            Vresultat
        );
    end loop;
end;
/

--Peuplement pour les intervalles de résultats de sang à exécuter avant d'exécuter les tests
CALL Intervalles_resultats_sang_peuplement('Cholesterol', 2, 5, 0, 7);
CALL Intervalles_resultats_sang_peuplement('Glycemie', 2, 5, 0, 7);
CALL Intervalles_resultats_sang_peuplement('Plaquettes', 2, 5, 0, 7);
CALL Intervalles_resultats_sang_peuplement('4', 2, 5, 0, 7);
CALL Intervalles_resultats_sang_peuplement('5', 2, 5, 0, 7);
CALL Intervalles_resultats_sang_peuplement('6', 2, 5, 0, 7);


call Peuplement_Centre();
CALL Peuplement_ARC ('Kys', 'Raoult');
CALL Peuplement_Medecin (123456789, 'Generaliste', 1, 'Micheldeux', 'Micheldeux');
CALL Peuplement_Medecin (987654321, 'Generaliste', 2, 'Leroy', 'Geraldine');
CALL Peuplement_patient('Richard', 'Test', 'M', TO_DATE('2001-01-19', 'YYYY-MM-DD'), 101022652352144, 1, 0, 0, 0, 1);
CALL Peuplement_Auxiliaire (135790246, 'infirmier','Lefevre', 'Sophie');
CALL Peuplement_Auxiliaire (135791113, 'infirmier','Dubois', 'Edouard');
CALL Peuplement_Auxiliaire (151719212, 'kinesitherapeuthe','Moulin', 'Jean');


CALL Peuplement_Analyse_Effort (1, SYSDATE, 0, 100, 100, 100);
CALL Peuplement_PCR_Covid (1, SYSDATE, 'Negatif');
CALL Peuplement_Analyse_Sang (1, SYSDATE, 0, 3, 3, 3, 3, 3, 3);

call Peuplement_Visite_Quotidienne(135790246, 1050, 1, 123456789, SYSDATE, 100, 13, 90, 37, 1, 2);
call Peuplement_Visite_Quotidienne(135790246, 101, 1, 123456789, SYSDATE, 100, 13, 90, 37, 1, 2);
call Peuplement_Visite_Quotidienne(135790246, 6408, 66, 123456789, SYSDATE, 100, 13, 90, 37, 1, 8);
CALL Peuplement_Lots (000101, 'TV');
CALL Peuplement_Lots (000102, 'PP');
CALL Peuplement_Lots (000103, 'PP');
CALL Peuplement_Lots (000104, 'TV');
call Peupler(100);




