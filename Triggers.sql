--##########################################################################################################################################################################################################
--################### TRIGGER DATE PROCHAINE ANALYSE PCR COVID ###########################################################################################################################################################################
--##########################################################################################################################################################################################################

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


--##########################################################################################################################################################################################################
--################### TRIGGER DATE PROCHAINE ANALYSE DE SANG ###########################################################################################################################################################################
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
            -- R�cup�ration des informations sur le patient
            SELECT Hypertension, Obesite, Menopause 
            INTO v_hypertension, v_obesite, v_menopause 
            FROM Patient 
            WHERE Id_Patient = :NEW.Id_Patient;
            
            -- Mise � jour de la date de la prochaine analyse selon les conditions
            IF (:NEW.Complementaire_Sang = 1) AND (v_hypertension=1 OR v_obesite=1 OR v_menopause=1) THEN
                :NEW.Date_Prochaine_Analyse_Sang := :NEW.Date_Analyse_Sang + 2;
            ELSIF (:NEW.Complementaire_Sang = 0) AND (v_hypertension=1 OR v_obesite=1 OR v_menopause=1) THEN
                :NEW.Date_Prochaine_Analyse_Sang := :NEW.Date_Analyse_Sang + 3;
            ELSif (:NEW.Complementaire_Sang = 1) AND (v_hypertension=0 OR v_obesite=0 OR v_menopause=0) THEN
                :NEW.Date_Prochaine_Analyse_Sang := :NEW.Date_Analyse_Sang + 5;
            ELSE
                :NEW.Date_Prochaine_Analyse_Sang := :NEW.Date_Analyse_Sang + 6;
            END IF;
        END IF;

    
END;
/

--##########################################################################################################################################################################################################
--################### date prochaine analyse dans la table effort ###############################################################################################################################
--##########################################################################################################################################################################################################
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

--##########################################################################################################################################################################################################
--################### Exclusion de patient pour l'age et les maladies graves ###############################################################################################################################
--##########################################################################################################################################################################################################

CREATE OR REPLACE TRIGGER Insertion_Patient_Exclusion
BEFORE INSERT OR UPDATE ON PATIENT
FOR EACH ROW
DECLARE
    v_age_patient INT;
BEGIN
--Calcul de l'age du patient
    v_age_patient := TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.DDN_Patient) / 12);

    IF (v_age_patient < 18 OR v_age_patient > 65) THEN
        IF INSERTING THEN
            RAISE_APPLICATION_ERROR(-20010, 'Probl�me d''�ge : Le patient ne r�pond pas aux crit�res d''�ge.');
        END IF;
        
        IF UPDATING THEN
            DELETE FROM PATIENT WHERE Id_Patient = :OLD.Id_Patient;
            RAISE_APPLICATION_ERROR(-20020, 'Probl�me d''�ge : Le patient ne r�pond pas aux crit�res d''�ge et a �t� supprim�.');
        END IF;
    END IF;

    IF (:NEW.OBESITE = 1 AND :NEW.HYPERTENSION = 1) THEN
        IF INSERTING THEN
            RAISE_APPLICATION_ERROR(-20030, 'Probl�me de maladies graves : le patient a trop de maladie grave, il ne peut pas �tre inclus.');
        END IF;
        
        IF UPDATING THEN
            DELETE FROM PATIENT WHERE Id_Patient = :OLD.Id_Patient;
            RAISE_APPLICATION_ERROR(-20040, 'Probl�me de maladies graves : le patient a trop de maladie grave, il ne peut plus �tre inclus et a �t� supprim�.');
        END IF;
    END IF;
END Insertion_Patient_Exclusion;
/
