--##########################################################################################################################################################################################################
--################### TESTS TABLE SANG_ANALYSE ###########################################################################################################################################################################
--##########################################################################################################################################################################################################


--###################
--################### Test de la date de la prochaine analyse si non complémentaire, pas de maladies graves et tous les résultats sont dans les normes

CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_Sang_No_complementaire_NoMaladieGrave_GoodResults AS
    v_id_patient INT;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
BEGIN
    -- créer un arc et sélectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCSang1Nom', 'TestARCSang1Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCSang1Nom';
    
    --créer un médecin et sélectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestSang1', 'MichelTestSang1');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestSang1';
    
    --créer un patient sans maladie grave et sélectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestSang1Nom', 'TestSang1Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestSang1Prenom';
    
    --créer une analyse de sang de ce patient non complémentaire et tous les résultats dans les normes
    INSERT INTO Sang_Analyse (Id_Patient, Date_Analyse_Sang, Complementaire_Sang, Resultat_Cholesterol, Resultat_Glycemie, Resultat_Plaquettes, Resultat_4, Resultat_5, Resultat_6)
    VALUES (v_id_patient, SYSDATE, 0, 3, 3, 3, 3, 3, 3);
    --sélectionner la date de la prochaine analyse
    SELECT Date_Prochaine_Analyse_Sang INTO v_date_prochaine_analyse FROM Sang_Analyse WHERE Id_Patient = v_id_patient;
    
    --si elle est bien égale à j+6
    IF (v_date_prochaine_analyse = SYSDATE + 6) THEN
        ROLLBACK;
        --test réussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_No_complementaire_NoMaladieGrave_GoodResults', 'Succès');
        COMMIT;
    ELSE
        ROLLBACK;
        --sinon, test non réussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_No_complementaire_NoMaladieGrave_GoodResults', 'Fail');
        COMMIT;
    END IF;
END;
/

--exécution de la procédure test
CALL Test_Date_Prochaine_Analyse_Sang_No_complementaire_NoMaladieGrave_GoodResults();


--###################
--################### de la date de la prochaine analyse si complémentaire, pas de maladies graves et tous les résultats sont dans les normes
CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_Sang_Complementaire_NoMaladieGrave_GoodResults AS
    v_id_patient INT;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
BEGIN
    -- créer un arc et sélectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCSang2Nom', 'TestARCSang2Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCSang2Nom';
    
    --créer un médecin et sélectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestSang2', 'MichelTestSang2');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestSang2';
    
    --créer un patient sans maladie grave et sélectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestSang2Nom', 'TestSang2Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestSang2Prenom';
    
    --créer une analyse de sang de ce patient complémentaire et tous les résultats dans les normes
    INSERT INTO Sang_Analyse (Id_Patient, Date_Analyse_Sang, Complementaire_Sang, Resultat_Cholesterol, Resultat_Glycemie, Resultat_Plaquettes, Resultat_4, Resultat_5, Resultat_6)
    VALUES (v_id_patient, SYSDATE, 1, 3, 3, 3, 3, 3, 3);
    --sélectionner la date de la prochaine analyse
    SELECT Date_Prochaine_Analyse_Sang INTO v_date_prochaine_analyse FROM Sang_Analyse WHERE Id_Patient = v_id_patient;
    
    --si elle est bien égale à j+5
    IF (v_date_prochaine_analyse = SYSDATE + 5) THEN
        ROLLBACK;
        --test réussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_Complementaire_NoMaladieGrave_GoodResults', 'Succès');
        COMMIT;
    ELSE
        ROLLBACK;
        --sinon, test non réussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_Complementaire_NoMaladieGrave_GoodResults', 'Fail');
        COMMIT;
    END IF;
END;
/

--exécution de la procédure test
CALL Test_Date_Prochaine_Analyse_Sang_Complementaire_NoMaladieGrave_GoodResults();


--###################
--################### de la date de la prochaine analyse si complémentaire, 1 des maladies graves et tous les résultats sont dans les normes
CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_Sang_Complementaire_OUIMaladieGrave_GoodResults AS
    v_id_patient INT;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
BEGIN
    -- créer un arc et sélectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCSang3Nom', 'TestARCSang3Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCSang3Nom';
    
    --créer un médecin et sélectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestSang3', 'MichelTestSang3');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestSang3';
    
    --créer un patient avec maladie grave et sélectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestSang3Nom', 'TestSang3Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 1, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestSang3Prenom';
    
    --créer une analyse de sang de ce patient complémentaire et tous les résultats dans les normes
    INSERT INTO Sang_Analyse (Id_Patient, Date_Analyse_Sang, Complementaire_Sang, Resultat_Cholesterol, Resultat_Glycemie, Resultat_Plaquettes, Resultat_4, Resultat_5, Resultat_6)
    VALUES (v_id_patient, SYSDATE, 1, 3, 3, 3, 3, 3, 3);
    --sélectionner la date de la prochaine analyse
    SELECT Date_Prochaine_Analyse_Sang INTO v_date_prochaine_analyse FROM Sang_Analyse WHERE Id_Patient = v_id_patient;
    
    --si elle est bien égale à j+2
    IF (v_date_prochaine_analyse = SYSDATE + 2) THEN
        ROLLBACK;
        --test réussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_Complementaire_OUIMaladieGrave_GoodResults', 'Succès');
        COMMIT;
    ELSE
        ROLLBACK;
        --sinon, test non réussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_Complementaire_OUIMaladieGrave_GoodResults', 'Fail');
        COMMIT;
    END IF;
END;
/

--exécution de la procédure test
CALL Test_Date_Prochaine_Analyse_Sang_Complementaire_OUIMaladieGrave_GoodResults();

--###################
--################### Test de la date de la prochaine analyse si non complémentaire, 1 des maladies graves et tous les résultats sont dans les normes
CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_Sang_NoComplementaire_MaladieGrave_GoodResults AS
    v_id_patient INT;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
BEGIN
    -- créer un arc et sélectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCSang3Nom', 'TestARCSang3Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCSang3Nom';
    
    --créer un médecin et sélectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestSang3', 'MichelTestSang3');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestSang3';
    
    --créer un patient avec maladie grave et sélectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestSang3Nom', 'TestSang3Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 1, 1, 1, 0, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestSang3Prenom';
    
    --créer une analyse de sang de ce patient non complémentaire et tous les résultats dans les normes
    INSERT INTO Sang_Analyse (Id_Patient, Date_Analyse_Sang, Complementaire_Sang, Resultat_Cholesterol, Resultat_Glycemie, Resultat_Plaquettes, Resultat_4, Resultat_5, Resultat_6)
    VALUES (v_id_patient, SYSDATE, 0, 3, 3, 3, 3, 3, 3);
    --sélectionner la date de la prochaine analyse
    SELECT Date_Prochaine_Analyse_Sang INTO v_date_prochaine_analyse FROM Sang_Analyse WHERE Id_Patient = v_id_patient;
    
    --si elle est bien égale à j+3
    IF (v_date_prochaine_analyse = SYSDATE + 3) THEN
        ROLLBACK;
        --test réussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_NoComplementaire_MaladieGrave_GoodResults', 'Succès');
        COMMIT;
    ELSE    
        ROLLBACK;
        --sinon, test non réussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_NoComplementaire_MaladieGrave_GoodResults', 'Fail');
        COMMIT;
        
    END IF;
END;
/

--exécution de la procédure test
CALL Test_Date_Prochaine_Analyse_Sang_NoComplementaire_MaladieGrave_GoodResults();

--###################
--################### Test de la date de la prochaine analyse si non complémentaire, pas de maladies graves mais 3 résultats sont hors normes
CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_Sang_NoComplementaire_NoMaladieGrave_BadResults AS
    v_id_patient INT;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
BEGIN
    -- créer un arc et sélectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCSang3Nom', 'TestARCSang3Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCSang3Nom';
    
    --créer un médecin et sélectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestSang3', 'MichelTestSang3');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestSang3';
    
    --créer un patient avec maladie grave et sélectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestSang3Nom', 'TestSang3Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestSang3Prenom';
    
    --créer une analyse de sang de ce patient non complémentaire et tous les résultats dans les normes
    INSERT INTO Sang_Analyse (Id_Patient, Date_Analyse_Sang, Complementaire_Sang, Resultat_Cholesterol, Resultat_Glycemie, Resultat_Plaquettes, Resultat_4, Resultat_5, Resultat_6)
    VALUES (v_id_patient, SYSDATE, 0, 3, 3, 3, 1, 1, 1);
    --sélectionner la date de la prochaine analyse
    SELECT Date_Prochaine_Analyse_Sang INTO v_date_prochaine_analyse FROM Sang_Analyse WHERE Id_Patient = v_id_patient;
    
    --si elle est bien égale à j+3
    IF (v_date_prochaine_analyse = SYSDATE + 0.21) THEN
        ROLLBACK;
        --test réussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_NoComplementaire_NoMaladieGrave_BadResults', 'Succès');
        COMMIT;
    ELSE
        ROLLBACK;
        --sinon, test non réussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_NoComplementaire_NoMaladieGrave_BadResults', 'Fail');
        COMMIT;
    END IF;
END;
/

--exécution de la procédure test
CALL Test_Date_Prochaine_Analyse_Sang_NoComplementaire_NoMaladieGrave_BadResults();


--##########################################################################################################################################################################################################
--################### TESTS TABLE PCR COVID ANALYSE ###########################################################################################################################################################################
--##########################################################################################################################################################################################################


--###################
--################### Test de la date de la prochaine analyse de pcr covid si résultat négatif et sans maladie grave

CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_PCR_ResultatNeg_NoMaladieGrave AS
    v_id_patient INT;
    v_date_analyse date;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
    v_date_fin_inclusion date;
    v_motif_fin_inclusion Patient.Motif_Fin_Inclusion%TYPE;
BEGIN
    -- créer un arc et sélectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCPCR3Nom', 'TestARCPCR3Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCPCR3Nom';
    
    --créer un médecin et sélectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestPCR3', 'MichelTestPCR3');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestPCR3';
    
    --créer un patient avec maladie grave et sélectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestPCR3Nom', 'TestPCR3Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestPCR3Prenom';
    
    --créer une analyse pcr covid avec un résultat négatif et non complémentaire
    INSERT INTO PCR_Covid_Analyse (Id_Patient, Date_Analyse_PCR_Covid, Resultat_PCR_Covid)
    VALUES (v_id_patient, SYSDATE, 'Negatif');
    --sélectionner la date de prochaine analyse
    SELECT Date_Prochaine_Analyse_PCR_Cov INTO v_date_prochaine_analyse FROM PCR_Covid_Analyse WHERE Id_Patient = v_id_patient;
    
    SELECT Date_Fin_Inclusion, Motif_Fin_Inclusion INTO v_date_fin_inclusion, v_motif_fin_inclusion FROM Patient WHERE Id_Patient = v_id_patient;
    
    
    if (v_date_prochaine_analyse = SYSDATE + 1 AND v_date_fin_inclusion = null AND v_motif_fin_inclusion = null) THEN
        ROLLBACK;
        --test réussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_PCR_ResultatNeg_NoMaladieGrave', 'Succès');
        COMMIT;
    else 
        RAISE_APPLICATION_ERROR(-20020, 'Not the good next day of PCR test for ' || v_id_patient);
        --test non réussi
        ROLLBACK;
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_PCR_ResultatNeg_NoMaladieGrave', 'Fail');
        COMMIT;
    end if;
END Test_Date_Prochaine_Analyse_PCR_ResultatNeg_NoMaladieGrave;
/

call Test_Date_Prochaine_Analyse_PCR_ResultatNeg_NoMaladieGrave();

--###################
--################### Test de la date de la prochaine analyse de pcr covid si résultat positif 

CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_PCR_ResultatPos AS
    v_id_patient INT;
    v_date_analyse date;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
    v_date_fin_inclusion date;
    v_motif_fin_inclusion Patient.Motif_Fin_Inclusion%TYPE;
    
BEGIN
    -- créer un arc et sélectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCPCR3Nom', 'TestARCPCR3Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCPCR3Nom';
    
    --créer un médecin et sélectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestPCR3', 'MichelTestPCR3');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestPCR3';
    
    --créer un patient avec maladie grave et sélectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestPCR3Nom', 'TestPCR3Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestPCR3Prenom';
    
    --créer une analyse pcr covid avec un résultat négatif et non complémentaire
    INSERT INTO PCR_Covid_Analyse (Id_Patient, Date_Analyse_PCR_Covid, Resultat_PCR_Covid)
    VALUES (v_id_patient, SYSDATE, 'Variant alpha detecte');
    --sélectionner la date de prochaine analyse et la date de l'analyse
    SELECT Date_Analyse_PCR_Covid, Date_Prochaine_Analyse_PCR_Cov INTO v_date_analyse, v_date_prochaine_analyse FROM PCR_Covid_Analyse WHERE Id_Patient = v_id_patient;
    --sélectionner la date et le motif de fin inclusion du patient
    SELECT Date_Fin_Inclusion, Motif_Fin_Inclusion INTO v_date_fin_inclusion, v_motif_fin_inclusion FROM Patient WHERE Id_Patient = v_id_patient;
    
    
    if (v_date_prochaine_analyse = SYSDATE AND v_date_fin_inclusion = v_date_analyse AND v_motif_fin_inclusion = null) THEN
        ROLLBACK;
        --test réussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_PCR_ResultatPos', 'Succès');
        COMMIT;
    else
        RAISE_APPLICATION_ERROR(-20030, 'Not the good next day of PCR test for' || v_id_patient);
        ROLLBACK;
        --test non réussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_PCR_ResultatPos', 'Fail');
        COMMIT;
    end if;
END Test_Date_Prochaine_Analyse_PCR_ResultatPos;
/

call Test_Date_Prochaine_Analyse_PCR_ResultatPos();

--##########################################################################################################################################################################################################
--################### TESTS TABLE EFFORT ANALYSE ###########################################################################################################################################################################
--##########################################################################################################################################################################################################


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

--##########################################################################################################################################################################################################
--################### TESTS RANDOMISATION ###########################################################################################################################################################################
--##########################################################################################################################################################################################################

--Permet de tester si les personnes de + de 50ans sont mises dans les bons groupes
CREATE OR REPLACE PROCEDURE TestRandomisationAge deterministic AS

    nbPatient NUMBER;
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO PATIENT (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
        VALUES (123456789, 'Rouget', 'Frederic', 'M', TO_DATE('22/03/1970', 'DD-MM-YYYY'), 2122345678912, 1, 1, 1, 0, 0, null, null);
    END LOOP;
    select count(*) into nbPatient from PATIENT where NOM_PATIENT = 'Rouget' AND TYPE_GROUPE <> 'PP' AND TYPE_SOUS_GROUPE = 1;
    if nbPatient=0 then
        rollback; 
        insert into TESTS_BDD (Nom_Test, Resultat_Test) values('TestRandomisationAge', 'Test réussi');
        commit; 
    elsif nbPatient<>0 then 
        rollback; 
        insert into TESTS_BDD (Nom_Test, Resultat_Test) values('TestRandomisationAge', 'Echec du tri des personnes de + de 50 ans');
        commit; 
    end if;
END;
/
call TestRandomisationAge();

--##########################################################################################################################################################################################################
--################### TESTS TABLE VISITE QUOTIDIENNE ET LOT ###########################################################################################################################################################################
--##########################################################################################################################################################################################################

CREATE OR REPLACE PROCEDURE test_verif_existance_lot_administre_positif AS
    v_lot_exists NUMBER;
    v_id_arc number;
    v_id_ec number;
    prediction_lot number;
    v_id_patient number;
    BEGIN
        INSERT INTO centre_ec (Nom_centre)
        VALUES ('Maragolles');
        --select ID_centre_ec into v_id_ec from centre_ec where Nom_centre = 'Maragolles';
        
        INSERT INTO ARC (Id_centre_ec, Nom_ARC, Prenom_ARC)
        VALUES (1, 'TestLotExistant', 'Mariline');
        select ID_ARC into v_id_arc from ARC where Nom_ARC = 'TestLotExistant';

        INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Id_centre_ec, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin)
        VALUES (999888777, v_id_arc, 1, 'generaliste', 45, 'Pin', 'Marie');
        
        INSERT INTO AUXILIAIRE (Num_ADELI_Auxiliaire, Id_centre_ec, Specialite_Auxiliaire, Nom_Auxiliaire, Prenom_Auxiliaire)
        VALUES (111222333, 1, 'infirmier', 'Racine', 'George');
        
        INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
        VALUES (999888777, 'TestExistanceLotNom', 'TestExistanceLotPrenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
        SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestExistanceLotPrenom';
        
        prediction_lot := TO_NUMBER(TO_CHAR(v_id_patient) || '01');
        
        -- Insertion d'une visite quotidienne avec un numéro de lot existant
        INSERT INTO VISITE_QUOTIDIENNE (NUM_ADELI_AUXILIAIRE, NUMERO_LOT, ID_PATIENT, NUM_ADELI_MEDECIN, DATE_VISITE_QUOTIDIENNE, POIDS, PRESSION_ARTERIELLE, RYTHME_CARDIAQUE, TEMPERATURE, DEBUT_DE_JOURNEE, JOUR_ETUDE)
        VALUES (111222333, prediction_lot, v_id_patient, 999888777, SYSDATE, 70, 120, 80, 37, 1, 1);

        -- Vérification si le numéro de lot existe dans la table LOTS
        SELECT COUNT(*) INTO v_lot_exists
        FROM LOTS
        WHERE NUMERO_LOT = prediction_lot;
        
        -- Insertion du résultat du test dans la table TESTS_BDD
        IF v_lot_exists = 1 THEN
            ROLLBACK;
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test positif existence numéro de lot', 'Réussi');
        ELSE
            ROLLBACK;
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test positif existence numéro de lot', 'Échoué');
        END IF;
END;
call test_verif_existance_lot_administre_positif();

--------------------------------------------------------------------------------------------------------------------------------
    
CREATE OR REPLACE PROCEDURE test_verif_existance_lot_administre_negatif AS
    v_lot_exists NUMBER;
    v_id_arc number;
    v_id_ec number;
    prediction_lot number;
    v_id_patient number;
    BEGIN
        INSERT INTO centre_ec (Nom_centre)
        VALUES ('Maragolles');
        
        INSERT INTO ARC (Id_centre_ec, Nom_ARC, Prenom_ARC)
        VALUES (1, 'TestLotExistant', 'Mariline');
        select ID_ARC into v_id_arc from ARC where Nom_ARC = 'TestLotExistant';

        INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Id_centre_ec, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin)
        VALUES (999888777, v_id_arc, 1, 'generaliste', 45, 'Pin', 'Marie');
        
        INSERT INTO AUXILIAIRE (Num_ADELI_Auxiliaire, Id_centre_ec, Specialite_Auxiliaire, Nom_Auxiliaire, Prenom_Auxiliaire)
        VALUES (111222333, 1, 'infirmier', 'Racine', 'George');
        
        INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
        VALUES (999888777, 'TestExistanceLotNom', 'TestExistanceLotPrenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
        SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestExistanceLotPrenom';
        
        --prediction_lot := TO_NUMBER(TO_CHAR(v_id_patient) || '01');
        
        -- Insertion d'une visite quotidienne avec un numéro de lot existant
        INSERT INTO VISITE_QUOTIDIENNE (NUM_ADELI_AUXILIAIRE, NUMERO_LOT, ID_PATIENT, NUM_ADELI_MEDECIN, DATE_VISITE_QUOTIDIENNE, POIDS, PRESSION_ARTERIELLE, RYTHME_CARDIAQUE, TEMPERATURE, DEBUT_DE_JOURNEE, JOUR_ETUDE)
        VALUES (111222333, 023405, v_id_patient, 999888777, SYSDATE, 70, 120, 80, 37, 1, 1);

        -- Vérification si le numéro de lot existe dans la table LOTS
        SELECT COUNT(*) INTO v_lot_exists
        FROM LOTS
        WHERE NUMERO_LOT = 023405;
        
        -- Insertion du résultat du test dans la table TESTS_BDD
        IF v_lot_exists = 1 THEN
            ROLLBACK;
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test insertion avec numéro de lot inexistant', 'Réussi');
        ELSE
            ROLLBACK;
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test insertion avec numéro de lot inexistant', 'Échoué');
        END IF;
END;
call test_verif_existance_lot_administre_negatif();

---------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE test_verif_lot_administre_positif AS
    v_lot_exists NUMBER;
    v_id_arc number;
    v_id_ec number;
    prediction_lot number;
    v_id_patient number;
    v_id_patient2 number;
    v_date_fin_inclusion date;
    BEGIN
        INSERT INTO centre_ec (Nom_centre)
        VALUES ('Maragolles');
        
        INSERT INTO ARC (Id_centre_ec, Nom_ARC, Prenom_ARC)
        VALUES (1, 'TestLotExistant', 'Mariline');
        select ID_ARC into v_id_arc from ARC where Nom_ARC = 'TestLotExistant';

        INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Id_centre_ec, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin)
        VALUES (999888777, v_id_arc, 1, 'generaliste', 45, 'Pin', 'Marie');
        
        INSERT INTO AUXILIAIRE (Num_ADELI_Auxiliaire, Id_centre_ec, Specialite_Auxiliaire, Nom_Auxiliaire, Prenom_Auxiliaire)
        VALUES (111222333, 1, 'infirmier', 'Racine', 'George');
        
        INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
        VALUES (999888777, 'TestVerifLotNom', 'TestVerifLotPrenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
        SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestVerifLotPrenom';
        
        iNSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
        VALUES (999888777, 'TestVerifLotNom2', 'TestVerifLotPrenom2', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
        SELECT Id_Patient INTO v_id_patient2 FROM Patient WHERE Prenom_Patient = 'TestVerifLotPrenom2';
        
        prediction_lot := TO_NUMBER(TO_CHAR(v_id_patient) || '01');
        
        -- Insertion d'une visite quotidienne avec un numéro de lot existant
        INSERT INTO VISITE_QUOTIDIENNE (NUM_ADELI_AUXILIAIRE, NUMERO_LOT, ID_PATIENT, NUM_ADELI_MEDECIN, DATE_VISITE_QUOTIDIENNE, POIDS, PRESSION_ARTERIELLE, RYTHME_CARDIAQUE, TEMPERATURE, DEBUT_DE_JOURNEE, JOUR_ETUDE)
        VALUES (111222333, prediction_lot, v_id_patient2, 999888777, SYSDATE, 70, 120, 80, 37, 1, 1);

        -- Vérification si le patient 2 est exclu ou non 
        SELECT DATE_FIN_INCLUSION
        INTO v_date_fin_inclusion
        FROM PATIENT
        WHERE ID_PATIENT = v_id_patient2;
        
        IF v_date_fin_inclusion IS NOT NULL THEN
            ROLLBACK;
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test positif verification de l erreur de lot', 'Échoué');
        ELSE
            ROLLBACK;
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test positif verification de l erreur de lot', 'Réussi');
        END IF;
END;
call test_verif_lot_administre_positif();   

-----------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE test_verif_lot_administre_negatif AS
    v_lot_exists NUMBER;
    v_id_arc number;
    v_id_ec number;
    prediction_lot number;
    v_id_patient number;
    v_id_patient2 number;
    v_date_fin_inclusion date;
    BEGIN
        INSERT INTO centre_ec (Nom_centre)
        VALUES ('Maragolles');
        
        INSERT INTO ARC (Id_centre_ec, Nom_ARC, Prenom_ARC)
        VALUES (1, 'TestLotExistant', 'Mariline');
        select ID_ARC into v_id_arc from ARC where Nom_ARC = 'TestLotExistant';

        INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Id_centre_ec, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin)
        VALUES (999888777, v_id_arc, 1, 'generaliste', 45, 'Pin', 'Marie');
        
        INSERT INTO AUXILIAIRE (Num_ADELI_Auxiliaire, Id_centre_ec, Specialite_Auxiliaire, Nom_Auxiliaire, Prenom_Auxiliaire)
        VALUES (111222333, 1, 'infirmier', 'Racine', 'George');
        
        INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
        VALUES (999888777, 'TestVerifLotNom', 'TestVerifLotPrenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'VP', 2);
        SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestVerifLotPrenom';
        
        iNSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
        VALUES (999888777, 'TestVerifLotNom2', 'TestVerifLotPrenom2', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'TP', 3);
        SELECT Id_Patient INTO v_id_patient2 FROM Patient WHERE Prenom_Patient = 'TestVerifLotPrenom2';
        
        prediction_lot := TO_NUMBER(TO_CHAR(v_id_patient) || '06');
        
        -- Insertion d'une visite quotidienne avec un numéro de lot existant
        INSERT INTO VISITE_QUOTIDIENNE (NUM_ADELI_AUXILIAIRE, NUMERO_LOT, ID_PATIENT, NUM_ADELI_MEDECIN, DATE_VISITE_QUOTIDIENNE, POIDS, PRESSION_ARTERIELLE, RYTHME_CARDIAQUE, TEMPERATURE, DEBUT_DE_JOURNEE, JOUR_ETUDE)
        VALUES (111222333, prediction_lot, v_id_patient2, 999888777, SYSDATE, 70, 120, 80, 37, 1, 6);

        -- Vérification si le patient 2 est exclu ou non 
        SELECT DATE_FIN_INCLUSION
        INTO v_date_fin_inclusion
        FROM PATIENT
        WHERE ID_PATIENT = v_id_patient2;
        
        IF v_date_fin_inclusion IS NOT NULL THEN
            ROLLBACK;
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test négatif verification de l erreur de lot', 'Réussi');
        ELSE
            ROLLBACK;
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test négatif verification de l erreur de lot', 'Echoué');
        END IF;
END;
call test_verif_lot_administre_negatif();  

-----------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE test_Remplissage_plan_de_prise_medoc AS
    v_lot_count NUMBER;
    v_id_patient number;
    v_id_arc number;
BEGIN
        INSERT INTO centre_ec (Nom_centre)
        VALUES ('Maragolles');
        
        INSERT INTO ARC (Id_centre_ec, Nom_ARC, Prenom_ARC)
        VALUES (1, 'TestLotExistant', 'Mariline');
        select ID_ARC into v_id_arc from ARC where Nom_ARC = 'TestLotExistant';

        INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Id_centre_ec, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin)
        VALUES (999888777, v_id_arc, 1, 'generaliste', 45, 'Pin', 'Marie');
        
        INSERT INTO PATIENT (NUM_ADELI_MEDECIN, NOM_PATIENT, PRENOM_PATIENT, SEXE_PATIENT, DDN_PATIENT, NUM_SECU_PATIENT, MENOPAUSE, VACCINATIONGRIPPE, VACCINATIONCOVID, HYPERTENSION, OBESITE, TYPE_GROUPE, TYPE_SOUS_GROUPE)
        VALUES (999888777, 'Nom_Test', 'Prenom_TestRemplissageLot', 'M', '2002-01-19', 202115936027333, 0, 1, 1, 0, 0, 'PP', 1);
        SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'Prenom_TestRemplissageLot';

    -- Vérifier si les lots ont été correctement ajoutés à la table LOTS pour le patient ajouté
        SELECT COUNT(*) INTO v_lot_count FROM LOTS WHERE SUBSTR(NUMERO_LOT, 1, LENGTH(TO_CHAR(v_id_patient))) = TO_CHAR(v_id_patient);
    
        IF v_lot_count = 15 THEN
            ROLLBACK;
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test remplissage automatique table lot verif patient', 'Réussi');
        ELSE
            ROLLBACK;
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test remplissage automatique table lot verif patient', 'Echoué');
        END IF;    
END;
/
call test_Remplissage_plan_de_prise_medoc();
-----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE test_Remplissage_plan_de_prise_medoc AS
    v_lot_count NUMBER;
    v_patient_id PATIENT.ID_PATIENT%TYPE;
BEGIN
    INSERT INTO centre_ec (Nom_centre)
    VALUES ('Maragolles');
    
    INSERT INTO ARC (Id_centre_ec, Nom_ARC, Prenom_ARC)
    VALUES (1, 'TestLotExistant', 'Mariline');
    SELECT ID_ARC INTO v_id_arc FROM ARC WHERE Nom_ARC = 'TestLotExistant';

    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Id_centre_ec, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin)
    VALUES (999888777, v_id_arc, 1, 'generaliste', 45, 'Pin', 'Marie');
    
    INSERT INTO PATIENT (NUM_ADELI_MEDECIN, NOM_PATIENT, PRENOM_PATIENT, SEXE_PATIENT, DDN_PATIENT, NUM_SECU_PATIENT, MENOPAUSE, VACCINATIONGRIPPE, VACCINATIONCOVID, HYPERTENSION, OBESITE, TYPE_GROUPE, TYPE_SOUS_GROUPE)
    VALUES (999888777, 'Nom_Test', 'Prenom_TestRemplissageLot', 'M', '2002-01-19', 202115936027333, 0, 1, 1, 0, 0, 'PP', 1);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'Prenom_TestRemplissageLot';

    -- Vérification si les lots ont été correctement ajoutés à la table LOTS pour le patient ajouté
    SELECT COUNT(*) INTO v_lot_count FROM LOTS WHERE SUBSTR(NUMERO_LOT, 1, LENGTH(TO_CHAR(v_patient_id))) = TO_CHAR(v_patient_id);

    -- Vérification si les deux derniers chiffres du numéro de lot correspondent bien au jour d'étude
    FOR lot_row IN (SELECT NUMERO_LOT FROM LOTS WHERE SUBSTR(NUMERO_LOT, 1, LENGTH(TO_CHAR(v_patient_id))) = TO_CHAR(v_patient_id)) LOOP
        IF TO_NUMBER(SUBSTR(lot_row.NUMERO_LOT, -2)) <> lot_row.RANG_JOUR_ETUDE THEN
            ROLLBACK;
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test correspondance jour d\'étude dans le numéro de lot', 'Échoué');
            RETURN;
        END IF;
    END LOOP;

    IF v_lot_count = 15 THEN
        ROLLBACK;
        INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test remplissage automatique table lot', 'Réussi');
    ELSE
        ROLLBACK;
        INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test remplissage automatique table lot', 'Échoué');
    END IF;    
END;



