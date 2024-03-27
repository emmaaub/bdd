--##################################################################################################################################################################################
--################### ARC ##########################################################################################################################################################
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
--################### MEDECIN ###########################################################################################################################################################################
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
CALL Peuplement_Medecin (123456788, 'Generaliste', 1, 'Micheldeux', 'Micheldeux');

--##########################################################################################################################################################################################################
--################### PATIENT ###########################################################################################################################################################################
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
    Pobesite int,
    Pgroupe varchar2,
    Psousgroupe int)
AS
PNumADELIM int;
BEGIN
    SELECT Num_ADELI_Medecin INTO PNumADELIM FROM Medecin WHERE Num_ADELI_Medecin = 123456788;
    
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (PNumADELIM, Pnom, PPrenom, Psexe, PDDN, PNumSecu, Pmeno, Pgrippe, Pcovid, Phypertension, Pobesite, Pgroupe, Psousgroupe);
    COMMIT;
END Peuplement_patient;
/


ALTER TRIGGER COMPOUNDINSERTTRIGGER_PATIENT DISABLE;
CALL Peuplement_patient('Richard', 'Malade', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 101022652352144, 1, 1, 1, 1, 1, 'PP', 3);


--##########################################################################################################################################################################################################
--################### INTERVALLES SANG ###########################################################################################################################################################################
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

CALL Intervalles_resultats_sang_peuplement('6', 2, 5, 0, 7);
--##########################################################################################################################################################################################################
--###################ANALYSE SANG###########################################################################################################################################################################
--##########################################################################################################################################################################################################

CREATE OR REPLACE TRIGGER verifier_concentration_trigger
BEFORE INSERT OR UPDATE ON Sang_Analyse 
FOR EACH ROW
DECLARE
    v_nb_analyse_hors_norme NUMBER := 0;
    v_complementaire INTEGER;
    v_hypertension INTEGER; 
    v_obesite INTEGER;
    v_menopause INTEGER;
    v_normal_chol_1 INTEGER;
    v_normal_chol_2 INTEGER;
    v_anormal_chol_1 INTEGER;
    v_anormal_chol_2 INTEGER;
    v_normal_gly_1 INTEGER;
    v_normal_gly_2 INTEGER;
    v_anormal_gly_1 INTEGER;
    v_anormal_gly_2 INTEGER;
    v_normal_plaq_1 INTEGER;
    v_normal_plaq_2 INTEGER;
    v_anormal_plaq_1 INTEGER;
    v_anormal_plaq_2 INTEGER;
    v_normal_4_1 INTEGER;
    v_normal_4_2 INTEGER;
    v_anormal_4_1 INTEGER;
    v_anormal_4_2 INTEGER;
    v_normal_5_1 INTEGER;
    v_normal_5_2 INTEGER;
    v_anormal_5_1 INTEGER;
    v_anormal_5_2 INTEGER;
    v_normal_6_1 INTEGER;
    v_normal_6_2 INTEGER;
    v_anormal_6_1 INTEGER;
    v_anormal_6_2 INTEGER;
BEGIN
  --##### CHOLESTEROL #####
    SELECT I_Normal_1, I_Normal_2, I_Anormal_1, I_Anormal_2 INTO v_normal_chol_1, v_normal_chol_2, v_anormal_chol_1, v_anormal_chol_2 FROM Intervalles_Resultats_Sang_Ana
    WHERE Type_Analyse = 'Cholesterol';
    
    If (:NEW.Resultat_Cholesterol IS NOT NULL) THEN
        IF (:NEW.Resultat_Cholesterol < v_normal_chol_1 OR :NEW.Resultat_Cholesterol > v_anormal_chol_2) AND 
           (:NEW.Resultat_Cholesterol > v_anormal_chol_1 OR :NEW.Resultat_Cholesterol < v_anormal_chol_2) THEN
            v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
        ELSIF (:NEW.Resultat_Cholesterol <= v_anormal_chol_1 OR :NEW.Resultat_Cholesterol >= v_anormal_chol_2) THEN
            v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
        END IF;
    END IF;
    
  --##### GLYCEMIE #####
    SELECT I_Normal_1, I_Normal_2, I_Anormal_1, I_Anormal_2 INTO v_normal_gly_1, v_normal_gly_2, v_anormal_gly_1, v_anormal_gly_2 FROM Intervalles_Resultats_Sang_Ana
    WHERE Type_Analyse = 'Glycemie';
    
    IF (:NEW.Resultat_Glycemie IS NOT NULL) THEN
        IF (:NEW.Resultat_Glycemie < v_normal_gly_1 OR :NEW.Resultat_Glycemie > v_normal_gly_2) AND 
           (:NEW.Resultat_Glycemie > v_anormal_gly_1 OR :NEW.Resultat_Glycemie < v_anormal_gly_2) THEN
            v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
        ELSIF (:NEW.Resultat_Glycemie <= v_anormal_gly_1 OR :NEW.Resultat_Glycemie >= v_anormal_gly_2) THEN
            v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
        END IF;
    END IF;
  --##### PLAQUETTES #####
    SELECT I_Normal_1, I_Normal_2, I_Anormal_1, I_Anormal_2 INTO v_normal_plaq_1, v_normal_plaq_2, v_anormal_plaq_1, v_anormal_plaq_2 FROM Intervalles_Resultats_Sang_Ana
    WHERE Type_Analyse = 'Plaquettes';
    
    IF (:NEW.Resultat_Plaquettes IS NOT NULL) then
        IF (:NEW.Resultat_Plaquettes < v_normal_plaq_1 OR :NEW.Resultat_Plaquettes > v_normal_plaq_2) AND 
           (:NEW.Resultat_Plaquettes > v_anormal_plaq_1 OR :NEW.Resultat_Plaquettes < v_anormal_plaq_2) THEN
            v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
        ELSIF (:NEW.Resultat_Plaquettes <= v_anormal_plaq_1 OR :NEW.Resultat_Plaquettes >= v_anormal_plaq_2) THEN
            v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
        END IF;
    END IF;
    
  --##### 4 #####
    SELECT I_Normal_1, I_Normal_2, I_Anormal_1, I_Anormal_2 INTO v_normal_4_1, v_normal_4_2, v_anormal_4_1, v_anormal_4_2 FROM Intervalles_Resultats_Sang_Ana
    WHERE Type_Analyse = '4';
    
    IF (:NEW.Resultat_4 IS NOT NULL) THEN
        IF (:NEW.Resultat_4 < v_normal_4_1 OR :NEW.Resultat_4 > v_normal_4_2) AND 
           (:NEW.Resultat_4 > v_anormal_4_1 OR :NEW.Resultat_4 < v_anormal_4_1) THEN
            v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
        ELSIF (:NEW.Resultat_4 <= v_anormal_4_1 OR :NEW.Resultat_4 >= v_anormal_4_2) THEN
            v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
        END IF;  
    END IF;
    
    
  --##### 5 #####  
    SELECT I_Normal_1, I_Normal_2, I_Anormal_1, I_Anormal_2 INTO v_normal_5_1, v_normal_5_2, v_anormal_5_1, v_anormal_5_2 FROM Intervalles_Resultats_Sang_Ana
    WHERE Type_Analyse = '5';
      
    IF (:NEW.Resultat_5 IS NOT NULL) THEN
        IF (:NEW.Resultat_5 < v_normal_5_1 OR :NEW.Resultat_5 > v_normal_5_2) AND 
        (:NEW.Resultat_5 > v_anormal_5_1 OR :NEW.Resultat_5 < v_anormal_5_2) THEN
            v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
        ELSIF (:NEW.Resultat_5 <= v_anormal_5_1 OR :NEW.Resultat_5 >= v_anormal_5_2) THEN
            v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
        END IF;
    END IF;
    
    
  --##### 6 #####  
    SELECT I_Normal_1, I_Normal_2, I_Anormal_1, I_Anormal_2 INTO v_normal_6_1, v_normal_6_2, v_anormal_6_1, v_anormal_6_2 FROM Intervalles_Resultats_Sang_Ana
    WHERE Type_Analyse = '6';
      
    IF (:NEW.Resultat_6 IS NOT NULL) THEN    
        IF (:NEW.Resultat_6 < v_normal_6_1 OR :NEW.Resultat_6 > v_normal_6_2) AND 
        (:NEW.Resultat_6 > v_anormal_6_1 OR :NEW.Resultat_6 < v_anormal_6_2) THEN
            v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
        ELSIF (:NEW.Resultat_6 <= v_anormal_6_1 OR :NEW.Resultat_6 >= v_anormal_6_2) THEN
            v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
        END IF;
    END IF;
    

        IF v_nb_analyse_hors_norme >= 3 THEN 
            :NEW.Date_Prochaine_Analyse_Sang := :NEW.Date_Analyse_Sang + 0.21;
        ELSE
            -- Récupération des informations sur le patient
            SELECT Hypertension, Obesite, Menopause 
            INTO v_hypertension, v_obesite, v_menopause 
            FROM Patient 
            WHERE Id_Patient = :NEW.Id_Patient;
            
            -- Mise à jour de la date de la prochaine analyse selon les conditions
            IF (:NEW.Complementaire_Sang = 1) AND (v_hypertension=1 OR v_obesite=1 OR v_menopause=1) THEN
                :NEW.Date_Prochaine_Analyse_Sang := :NEW.Date_Analyse_Sang + 5;
            ELSIF (:NEW.Complementaire_Sang = 0) AND (v_hypertension=1 OR v_obesite=1 OR v_menopause=1) THEN
                :NEW.Date_Prochaine_Analyse_Sang := :NEW.Date_Analyse_Sang + 3;
            ELSE
                :NEW.Date_Prochaine_Analyse_Sang := :NEW.Date_Analyse_Sang + 6;
            END IF;
        END IF;

    
END;
/

    
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
--###################ANALYSE PCR COVID###########################################################################################################################################################################
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

CREATE OR REPLACE TRIGGER date_pcr_trigger
BEFORE INSERT OR UPDATE ON PCR_Covid_Analyse
FOR EACH ROW
DECLARE
    v_id_patient PCR_Covid_Analyse.Id_Patient%TYPE;
    v_hypertension Patient.Hypertension%TYPE;
    v_obesite Patient.Obesite%TYPE;
    v_menopause Patient.Menopause%TYPE;
BEGIN
    SELECT Hypertension, Obesite, Menopause INTO v_hypertension, v_obesite, v_menopause FROM Patient WHERE Id_Patient = :NEW.Id_Patient;
    
    IF (:NEW.Resultat_PCR_Covid = 'Negatif') THEN
        IF (v_hypertension = 1 OR v_obesite = 1 OR v_menopause = 1) THEN
            :NEW.Date_Prochaine_Analyse_PCR_Cov := :NEW.Date_Analyse_PCR_Covid;
        ELSE
            :NEW.Date_Prochaine_Analyse_PCR_Cov := :NEW.Date_Analyse_PCR_Covid + 1;
        END IF;
        
        UPDATE Patient 
        SET Date_Fin_Inclusion = NULL,
            Motif_Fin_Inclusion = NULL 
        WHERE Id_Patient = :NEW.Id_Patient;
        
    ELSIF (:NEW.Resultat_PCR_Covid in ('Variant alpha detecte', 'Variant delta detecte', 'Variant omega detecte')) THEN
        :NEW.Date_Prochaine_Analyse_PCR_Cov := :NEW.Date_Analyse_PCR_Covid;

        
        UPDATE Patient 
        SET Date_Fin_Inclusion = :NEW.Date_Analyse_PCR_Covid,
            Motif_Fin_Inclusion = 'PCR Covid Positive' 
        WHERE Id_Patient = :NEW.Id_Patient;
    END IF;
END;
/


ALTER TRIGGER COMPOUNDINSERTTRIGGER_PCR_COVI DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_PCR_COVI DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_PATIENT DISABLE;

CALL Peuplement_PCR_Covid (2, SYSDATE, 'Negatif');

