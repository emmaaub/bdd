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
            -- Récupération des informations sur le patient
            SELECT Hypertension, Obesite, Menopause 
            INTO v_hypertension, v_obesite, v_menopause 
            FROM Patient 
            WHERE Id_Patient = :NEW.Id_Patient;
            
            -- Mise à jour de la date de la prochaine analyse selon les conditions
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
            RAISE_APPLICATION_ERROR(-20010, 'Problème d''âge : Le patient ne répond pas aux critères d''âge.');
        END IF;
        
        IF UPDATING THEN
            DELETE FROM PATIENT WHERE Id_Patient = :OLD.Id_Patient;
            RAISE_APPLICATION_ERROR(-20020, 'Problème d''âge : Le patient ne répond pas aux critères d''âge et a été supprimé.');
        END IF;
    END IF;

    IF (:NEW.OBESITE = 1 AND :NEW.HYPERTENSION = 1) THEN
        IF INSERTING THEN
            RAISE_APPLICATION_ERROR(-20030, 'Problème de maladies graves : le patient a trop de maladie grave, il ne peut pas être inclus.');
        END IF;
        
        IF UPDATING THEN
            DELETE FROM PATIENT WHERE Id_Patient = :OLD.Id_Patient;
            RAISE_APPLICATION_ERROR(-20040, 'Problème de maladies graves : le patient a trop de maladie grave, il ne peut plus être inclus et a été supprimé.');
        END IF;
    END IF;
END Insertion_Patient_Exclusion;
/


--####################################################################################################################################
--###################################### RANDOMISATION PATIENT ###########################################################
--####################################################################################################################################


CREATE OR REPLACE TRIGGER RandomizeGroupAndSubgroupVersionHaute
BEFORE INSERT ON PATIENT
FOR EACH ROW
DECLARE
    total_tv NUMBER := 0;
    total_tp NUMBER := 0;
    total_vp NUMBER := 0;
    total_pp NUMBER := 0;
    chosen_group VARCHAR2(10);
    chosen_subgroup NUMBER := 0;
    age_patient NUMBER := 0;
    min_group_size NUMBER := 0;
    chosen_subgroup_random NUMBER := 0;
    chosen_group_random VARCHAR2(10);
BEGIN
    -- Calculer le nombre de patients actuels dans chaque groupe
    SELECT COUNT(*) INTO total_tv FROM PATIENT WHERE Type_Groupe = 'TV';
    SELECT COUNT(*) INTO total_tp FROM PATIENT WHERE Type_Groupe = 'TP';
    SELECT COUNT(*) INTO total_vp FROM PATIENT WHERE Type_Groupe = 'VP';
    SELECT COUNT(*) INTO total_pp FROM PATIENT WHERE Type_Groupe = 'PP';

    -- Déterminer le minimum de patients parmi les groupes TV, TP, VP
    min_group_size := LEAST(total_tv, total_tp, total_vp, total_pp);

    -- Déterminer le nombre de patients par sous-groupe dans chaque groupe
    DECLARE
        num_tv_subgroup1 NUMBER := 0;
        num_tv_subgroup2 NUMBER := 0;
        num_tv_subgroup3 NUMBER := 0;
        num_tp_subgroup1 NUMBER := 0;
        num_tp_subgroup2 NUMBER := 0;
        num_tp_subgroup3 NUMBER := 0;
        num_vp_subgroup1 NUMBER := 0;
        num_vp_subgroup2 NUMBER := 0;
        num_vp_subgroup3 NUMBER := 0;
    BEGIN
        SELECT COUNT(*) INTO num_tv_subgroup1 FROM PATIENT WHERE Type_Groupe = 'TV' AND Type_Sous_Groupe = 1;
        SELECT COUNT(*) INTO num_tv_subgroup2 FROM PATIENT WHERE Type_Groupe = 'TV' AND Type_Sous_Groupe = 2;
        SELECT COUNT(*) INTO num_tv_subgroup3 FROM PATIENT WHERE Type_Groupe = 'TV' AND Type_Sous_Groupe = 3;
        SELECT COUNT(*) INTO num_tp_subgroup1 FROM PATIENT WHERE Type_Groupe = 'TP' AND Type_Sous_Groupe = 1;
        SELECT COUNT(*) INTO num_tp_subgroup2 FROM PATIENT WHERE Type_Groupe = 'TP' AND Type_Sous_Groupe = 2;
        SELECT COUNT(*) INTO num_tp_subgroup3 FROM PATIENT WHERE Type_Groupe = 'TP' AND Type_Sous_Groupe = 3;
        SELECT COUNT(*) INTO num_vp_subgroup1 FROM PATIENT WHERE Type_Groupe = 'VP' AND Type_Sous_Groupe = 1;
        SELECT COUNT(*) INTO num_vp_subgroup2 FROM PATIENT WHERE Type_Groupe = 'VP' AND Type_Sous_Groupe = 2;
        SELECT COUNT(*) INTO num_vp_subgroup3 FROM PATIENT WHERE Type_Groupe = 'VP' AND Type_Sous_Groupe = 3;

        -- Déterminer le sous-groupe avec le nombre minimum de patients dans chaque groupe
        CASE chosen_group
            WHEN 'TV' THEN
                IF num_tv_subgroup1 = 0 THEN
                    chosen_subgroup := 1;
                ELSIF num_tv_subgroup2 = 0 THEN
                    chosen_subgroup := 2;
                ELSIF num_tv_subgroup3 = 0 THEN
                    chosen_subgroup := 3;
                END IF;
            WHEN 'TP' THEN
                IF num_tp_subgroup1 = 0 THEN
                    chosen_subgroup := 1;
                ELSIF num_tp_subgroup2 = 0 THEN
                    chosen_subgroup := 2;
                ELSIF num_tp_subgroup3 = 0 THEN
                    chosen_subgroup := 3;
                END IF;
            WHEN 'VP' THEN
                IF num_vp_subgroup1 = 0 THEN
                    chosen_subgroup := 1;
                ELSIF num_vp_subgroup2 = 0 THEN
                    chosen_subgroup := 2;
                ELSIF num_vp_subgroup3 = 0 THEN
                    chosen_subgroup := 3;
                END IF;
            ELSE
                chosen_subgroup := 0;
        END CASE;
    END;

    -- Déterminer le groupe en fonction de la disponibilité de patients
    IF total_tv = 0 AND total_tp = 0 AND total_vp = 0 AND total_pp = 0 THEN
        -- Aucun patient dans TV, TP, VP et PP -> choisir aléatoirement parmi TV, TP, VP
        chosen_group_random := TRUNC(DBMS_RANDOM.VALUE(1, 5));
        if chosen_group_random = 1 then
            chosen_group := 'TV';
        elsif chosen_group_random = 2 then
            chosen_group := 'TP';
        elsif chosen_group_random = 3 then
            chosen_group := 'VP';
        elsif chosen_group_random = 4 then
            chosen_group := 'PP';
        end if;
    ELSIF total_tv > 0 AND total_tp > 0 AND total_vp > 0 AND total_pp > 0 THEN
        -- Tous les groupes sont non vides -> vérifier la taille de chaque groupe
        IF min_group_size = total_tv THEN
            chosen_group := 'TV';
        ELSIF min_group_size = total_tp THEN
            chosen_group := 'TP';
        ELSIF min_group_size = total_vp THEN
            chosen_group := 'VP';
        else
            chosen_group := 'PP';
        END IF;
    ELSE
        -- Un des groupes n'est pas vide -> choisir aléatoirement entre TV, TP, VP
        chosen_group_random := TRUNC(DBMS_RANDOM.VALUE(1, 5));
        if chosen_group_random = 1 then
            chosen_group := 'TV';
        elsif chosen_group_random = 2 then
            chosen_group := 'TP';
        elsif chosen_group_random = 3 then
            chosen_group := 'VP';
        elsif chosen_group_random = 4 then
            chosen_group := 'PP';
        end if;
    END IF;

    -- Déterminer le sous-groupe en fonction de l'âge du patient
    age_patient := TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.DDN_Patient) / 12);

    IF age_patient > 50 THEN
        IF chosen_group IN ('TV', 'TP', 'VP') THEN
            -- Si le patient a plus de 50 ans, assigner au sous-groupe 2 ou 3
            chosen_subgroup_random := TRUNC(DBMS_RANDOM.VALUE(1, 3));
                if chosen_subgroup_random = 1 then
                    chosen_subgroup := 2;
                else
                    chosen_subgroup := 3;
                end if;
        END IF;
    ELSE
        if chosen_group IN ('TV', 'TP', 'VP') THEN
            -- Sinon, choisir aléatoirement parmi les sous-groupes 1, 2, 3
            chosen_subgroup_random := TRUNC(DBMS_RANDOM.VALUE(1, 4));
                if chosen_subgroup_random = 1 then
                    chosen_subgroup := 1;
                elsif chosen_group_random = 2 then
                    chosen_subgroup := 2;
                else 
                    chosen_subgroup := 3;
                end if;
        else
            chosen_subgroup := 0;
        end if;
    END IF;

    -- Affecter le groupe et le sous-groupe choisis au nouveau patient
    :NEW.Type_Groupe := chosen_group;
    :NEW.Type_Sous_Groupe := chosen_subgroup;
END;
/

--####################################################################################################################################
--###################################### Contrainte pour les types de lots ###########################################################
--####################################################################################################################################

alter table Lots 
    add constraint DomaineTypeLots 
    check(TYPE_LOT in ('TV','TP','VP', 'PP')); 
    
--####################################################################################################################################
--###################################### Automatisation remplissage numéro de lot ###########################################################
--####################################################################################################################################
create or replace trigger Remplissage_plan_de_prise_medoc after insert on Patient
for each row
declare
    duree_etude integer; 
    v_num_lot LOTS.NUMERO_LOT%TYPE;
    v_type_lot LOTS.TYPE_LOT%TYPE;
BEGIN
    duree_etude:= 15; 
    -- Déterminer le type de lot en fonction du groupe et du sous-groupe du nouveau patient
IF :NEW.TYPE_GROUPE = 'PP' THEN

         v_type_lot := 'PP';
         FOR nb_jours IN 1..duree_etude LOOP -- Supposons une étude d'une durée maximale de 31 jours
            if nb_jours <10 then 
            v_num_lot := :NEW.ID_PATIENT || LPAD(nb_jours, 2, '0');
            else 
            v_num_lot := :NEW.ID_PATIENT || nb_jours;
            end if;
            
            INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
        END LOOP;
        
ELSIF :NEW.TYPE_GROUPE = 'TV' THEN
    
         IF :NEW.TYPE_SOUS_GROUPE = 1 THEN
         
            v_type_lot := 'TV';
            FOR nb_jours IN 1..duree_etude LOOP -- Supposons une étude d'une durée maximale de 31 jours
                if nb_jours <10 then 
                    v_num_lot := :NEW.ID_PATIENT || LPAD(nb_jours, 2, '0');
                else 
                    v_num_lot := :NEW.ID_PATIENT || nb_jours;
                end if;
                INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
            END LOOP;
        
        ELSIF :NEW.TYPE_SOUS_GROUPE = 2 THEN
        
        FOR jour_etude IN 1..duree_etude LOOP
            IF MOD(jour_etude, 2) = 0 THEN
                v_type_lot := 'PP';
                    if jour_etude <10 then 
                        v_num_lot := :NEW.ID_PATIENT || LPAD(jour_etude, 2, '0');
                    else 
                        v_num_lot := :NEW.ID_PATIENT || jour_etude;
                    end if;        
                INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
                
            ELSIF MOD(jour_etude, 2) <> 0 THEN
                v_type_lot := 'TV';
                    if jour_etude <10 then 
                        v_num_lot := :NEW.ID_PATIENT || LPAD(jour_etude, 2, '0');
                    else 
                        v_num_lot := :NEW.ID_PATIENT || jour_etude;
                    end if;        
                INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
            end if;
        end loop;
        
        ELSIF :NEW.TYPE_SOUS_GROUPE = 3 THEN
        
            FOR jour_etude IN 1..duree_etude LOOP
                IF MOD(jour_etude, 3) = 0 THEN
                    v_type_lot := 'TV';
                    if jour_etude <10 then 
                        v_num_lot := :NEW.ID_PATIENT || LPAD(jour_etude, 2, '0');
                    else 
                        v_num_lot := :NEW.ID_PATIENT || jour_etude;
                    end if;        
                    INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
                    
                ELSE
                    v_type_lot := 'PP';
                    if jour_etude <10 then 
                        v_num_lot := :NEW.ID_PATIENT || LPAD(jour_etude, 2, '0');
                    else 
                        v_num_lot := :NEW.ID_PATIENT || jour_etude;
                    end if;        
                    INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
               end if;
            end loop;
        end if;
        
        
ELSIF :NEW.TYPE_GROUPE = 'TP' THEN
  
        IF :NEW.TYPE_SOUS_GROUPE = 1 THEN
         
            v_type_lot := 'TP';
            FOR nb_jours IN 1..duree_etude LOOP -- Supposons une étude d'une durée maximale de 31 jours
                if nb_jours <10 then 
                    v_num_lot := :NEW.ID_PATIENT || LPAD(nb_jours, 2, '0');
                else 
                    v_num_lot := :NEW.ID_PATIENT || nb_jours;
                end if;
                INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
            END LOOP;
        
        ELSIF :NEW.TYPE_SOUS_GROUPE = 2 THEN
        
        FOR jour_etude IN 1..duree_etude LOOP
            IF MOD(jour_etude, 2) = 0 THEN
                v_type_lot := 'PP';
                    if jour_etude <10 then 
                        v_num_lot := :NEW.ID_PATIENT || LPAD(jour_etude, 2, '0');
                    else 
                        v_num_lot := :NEW.ID_PATIENT || jour_etude;
                    end if;        
                INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
                
            ELSIF MOD(jour_etude, 2) <> 0 THEN
                v_type_lot := 'TP';
                    if jour_etude <10 then 
                        v_num_lot := :NEW.ID_PATIENT || LPAD(jour_etude, 2, '0');
                    else 
                        v_num_lot := :NEW.ID_PATIENT || jour_etude;
                    end if;        
                INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
            end if;
        end loop;
        
        ELSIF :NEW.TYPE_SOUS_GROUPE = 3 THEN
        
            FOR jour_etude IN 1..duree_etude LOOP
                IF MOD(jour_etude, 3) = 0 THEN
                    v_type_lot := 'TP';
                    if jour_etude <10 then 
                        v_num_lot := :NEW.ID_PATIENT || LPAD(jour_etude, 2, '0');
                    else 
                        v_num_lot := :NEW.ID_PATIENT || jour_etude;
                    end if;        
                    INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
                    
                ELSE
                    v_type_lot := 'PP';
                    if jour_etude <10 then 
                        v_num_lot := :NEW.ID_PATIENT || LPAD(jour_etude, 2, '0');
                    else 
                        v_num_lot := :NEW.ID_PATIENT || jour_etude;
                    end if;        
                    INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
               end if;
            end loop;  
        end if;
        
ELSIF :NEW.TYPE_GROUPE = 'VP' THEN
        
    IF :NEW.TYPE_SOUS_GROUPE = 1 THEN
            v_type_lot := 'VP';
            FOR nb_jours IN 1..duree_etude LOOP -- Supposons une étude d'une durée maximale de 31 jours
                if nb_jours <10 then 
                    v_num_lot := :NEW.ID_PATIENT || LPAD(nb_jours, 2, '0');
                else 
                    v_num_lot := :NEW.ID_PATIENT || nb_jours;
                end if;
                INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
            END LOOP;
        
        ELSIF :NEW.TYPE_SOUS_GROUPE = 2 THEN
        
        FOR jour_etude IN 1..duree_etude LOOP
            IF MOD(jour_etude, 2) = 0 THEN
                v_type_lot := 'PP';
                    if jour_etude <10 then 
                        v_num_lot := :NEW.ID_PATIENT || LPAD(jour_etude, 2, '0');
                    else 
                        v_num_lot := :NEW.ID_PATIENT || jour_etude;
                    end if;        
                INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
                
            ELSIF MOD(jour_etude, 2) <> 0 THEN
                v_type_lot := 'VP';
                    if jour_etude <10 then 
                        v_num_lot := :NEW.ID_PATIENT || LPAD(jour_etude, 2, '0');
                    else 
                        v_num_lot := :NEW.ID_PATIENT || jour_etude;
                    end if;        
                INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
            end if;
        end loop;
        
        ELSIF :NEW.TYPE_SOUS_GROUPE = 3 THEN
        
            FOR jour_etude IN 1..duree_etude LOOP
                IF MOD(jour_etude, 3) = 0 THEN
                    v_type_lot := 'VP';
                    if jour_etude <10 then 
                        v_num_lot := :NEW.ID_PATIENT || LPAD(jour_etude, 2, '0');
                    else 
                        v_num_lot := :NEW.ID_PATIENT || jour_etude;
                    end if;        
                    INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
                    
                ELSE
                    v_type_lot := 'PP';
                    if jour_etude <10 then 
                        v_num_lot := :NEW.ID_PATIENT || LPAD(jour_etude, 2, '0');
                    else 
                        v_num_lot := :NEW.ID_PATIENT || jour_etude;
                    end if;        
                    INSERT INTO LOTS(NUMERO_LOT, TYPE_LOT) VALUES (v_num_lot, v_type_lot);
               end if;
            end loop;
        END IF;        
END IF;

END;
/


--####################################################################################################################################
--###################################### Automatisation ID_Test ###########################################################
--####################################################################################################################################

drop sequence IDTest;
create sequence IDTest;

create or replace trigger ValeurIDTest
before insert on TESTS_BDD for each row
begin
    select IDTest.nextval into :new.ID_TEST from dual;
end;
/






--####################################################################################################################################
--###################################### Verification lot administré ###########################################################
--####################################################################################################################################


create or replace trigger verif_existance_lot_administre before insert or update on VISITE_QUOTIDIENNE
FOR EACH ROW
DECLARE
    v_lot_exists NUMBER;
begin 
    -- Vérifier si le numéro de lot existe dans la table LOTS
    SELECT COUNT(*) INTO v_lot_exists
    FROM LOTS
    WHERE NUMERO_LOT = :NEW.NUMERO_LOT;
    -- Si le numéro de lot n'existe pas, déclencher une exception
    IF v_lot_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Le numéro de lot spécifié n''existe pas dans la table LOTS.');
    END IF;
end ;
/

--####################################################################################################################################
--###################################### Verification si meme type de lot en cas d'erreur ###########################################################
--####################################################################################################################################

CREATE OR REPLACE TRIGGER verif_lot_administre 
after INSERT OR UPDATE ON VISITE_QUOTIDIENNE 
FOR EACH ROW 
DECLARE
    p_chi NUMBER;
    d_chi NUMBER;
    v_type_lot_mauvais LOTS.TYPE_LOT%TYPE;
    prediction_lot NUMBER; -- Garder prediction_lot comme un nombre
    v_type_lot_prevu LOTS.TYPE_LOT%TYPE;
BEGIN
    -- Extraction des quatre premiers chiffres
    p_chi := TRUNC(:new.numero_lot / 100); -- Supprime les deux derniers chiffres
    -- Extraction des deux derniers chiffres (similaire aux exemples précédents)
    d_chi := MOD(:new.numero_lot, 100);
    
    -- Recherche du type de lot administré
    SELECT type_lot INTO v_type_lot_mauvais FROM Lots WHERE numero_lot = :new.numero_lot;
    
    -- Prédiction du type de lot qu'aurait dû prendre le patient
    prediction_lot := :NEW.Id_Patient * 100 + :new.jour_etude; -- Concaténation correcte pour obtenir le numéro de lot
    
    -- Sélection du type de lot prévu
    SELECT type_lot INTO v_type_lot_prevu FROM Lots WHERE numero_lot = prediction_lot;
    
    -- Vérification si le lot administré correspond au lot prévu
    IF v_type_lot_prevu <> v_type_lot_mauvais THEN
        -- Mise à jour des informations du patient
        UPDATE PATIENT SET date_fin_inclusion = SYSDATE, motif_fin_inclusion = 'Erreur d administration durant l essai' WHERE ID_PATIENT = :NEW.Id_Patient;
    END IF;
END;
/

/*==============================================================*/
/* Trigger : Génération d'ID  EEG_ANALYSE                                  */
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
/* Trigger : PROGRAMMATION prochaine analyse */
/*==============================================================*/
CREATE OR REPLACE TRIGGER trg_compound_eeg_analyse
FOR INSERT OR UPDATE ON EEG_ANALYSE
COMPOUND TRIGGER
    analysesPrecedentes NUMBER := 0;
    patientID EEG_ANALYSE.ID_PATIENT%TYPE;

    AFTER EACH ROW IS
    BEGIN
        patientID := :new.ID_PATIENT;
    END AFTER EACH ROW;
    AFTER STATEMENT IS
    BEGIN    
        --On doit vérifier que le patient à d'autres analyses pour les comparer
        SELECT COUNT(*)
        INTO analysesPrecedentes
        FROM EEG_ANALYSE
        WHERE ID_PATIENT = patientID;

        IF analysesPrecedentes > 0 THEN
            calculer_prochaine_analyse(patientID);
        END IF;
    END AFTER STATEMENT;

END trg_compound_eeg_analyse;
/








