--##################################################################################################################################################################################
--################### PEUPLEMENT ARC ##########################################################################################################################################################
--##################################################################################################################################################################################

CREATE OR REPLACE PROCEDURE Peuplement_ARC(
    PnomARC varchar2,
    PprenomARC varchar2
    )
IS
BEGIN
INSERT INTO ARC (Nom_ARC, Prenom_ARC)
    VALUES (PnomARC, PprenomARC);
    COMMIT;
END Peuplement_ARC;
/

ALTER TRIGGER COMPOUNDINSERTTRIGGER_ARC DISABLE;
CALL Peuplement_ARC ('Kys', 'Raoult');


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
BEGIN
    SELECT Id_ARC INTO PIDARC FROM ARC WHERE Id_ARC = 1;
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin)
    VALUES (PnumADELI, PIDARC, Pspe_med, Pcohorte, PNomM, PPrenomM);
    COMMIT;
    
END Peuplement_Medecin;
/

ALTER TRIGGER COMPOUNDINSERTTRIGGER_MEDECIN DISABLE;
CALL Peuplement_Medecin (123456789, 'Generaliste', 1, 'Micheldeux', 'Micheldeux');


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

ALTER TRIGGER COMPOUNDINSERTTRIGGER_PATIENT DISABLE;

CALL Peuplement_patient('Richard', 'Test', 'M', TO_DATE('2001-01-19', 'YYYY-MM-DD'), 101022652352144, 1, 0, 0, 0, 1);


--##########################################################################################################################################################################################################
--################### PEUPLEMENT INTERVALLES SANG ###########################################################################################################################################################################
--##########################################################################################################################################################################################################
ALTER TABLE Intervalles_resultats_sang_ana add constraint Nom_Type_Analyse
check (Type_Analyse in ('Cholesterol','Glycemie','Plaquettes','4','5','6'));

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

CALL Intervalles_resultats_sang_peuplement('Cholesterol', 2, 5, 0, 7);
CALL Intervalles_resultats_sang_peuplement('Glycemie', 2, 5, 0, 7);
CALL Intervalles_resultats_sang_peuplement('Plaquettes', 2, 5, 0, 7);
CALL Intervalles_resultats_sang_peuplement('4', 2, 5, 0, 7);
CALL Intervalles_resultats_sang_peuplement('5', 2, 5, 0, 7);
CALL Intervalles_resultats_sang_peuplement('6', 2, 5, 0, 7);



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

ALTER TRIGGER COMPOUNDINSERTTRIGGER_SANG_ANA DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_SANG_ANA DISABLE;

CALL Peuplement_Analyse_Sang (2, SYSDATE, 0, 3, 3, 3, 3, 3, 3);


--##########################################################################################################################################################################################################
--################### PEUPLEMENT ANALYSE PCR COVID ###########################################################################################################################################################################
--##########################################################################################################################################################################################################
alter table PCR_Covid_Analyse add constraint Nom_Resultats_PCR_Covid
check (Resultat_PCR_Covid in ('Negatif','Variant alpha detecte','Variant delta detecte','Variant omega detecte'));

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


ALTER TRIGGER COMPOUNDINSERTTRIGGER_PCR_COVI DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_PCR_COVI DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_PATIENT DISABLE;

CALL Peuplement_PCR_Covid (2, SYSDATE, 'Negatif');

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

ALTER TRIGGER COMPOUNDINSERTTRIGGER_EFFORT_A DISABLE;
ALTER TRIGGER COMPOUNDDELETETRIGGER_EFFORT_A DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_EFFORT_A DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_EFFORT_A DISABLE;
DELETE FROM EFFORT_ANALYSE;

CALL Peuplement_Analyse_Effort (46, SYSDATE, 0, 100, 100, 100);
/

