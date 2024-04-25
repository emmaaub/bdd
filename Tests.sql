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

CREATE OR REPLACE PROCEDURE test_verif_existance_lot_administre AS
    v_lot_exists NUMBER;
BEGIN
    -- Démarrer une transaction
    BEGIN
        -- Insertion d'un numéro de lot existant
        INSERT INTO LOTS (NUMERO_LOT, TYPE_LOT) VALUES (123401, 'PP');
        
        -- Insertion d'une visite quotidienne avec un numéro de lot existant
        INSERT INTO VISITE_QUOTIDIENNE (ID_VISITE_QUOTIDIENNE, NUM_ADELI_AUXILIAIRE, NUMERO_LOT, ID_PATIENT, NUM_ADELI_MEDECIN, DATE_VISITE_QUOTIDIENNE, POIDS, PRESSION_ARTERIELLE, RYTHME_CARDIAQUE, TEMPERATURE, COMMENTAIRE, DEBUT_DE_JOURNEE, JOUR_ETUDE)
        VALUES (1, 123456, 123401, 1234, 654321, SYSDATE, 70, 120, 80, 37, 'Aucun commentaire', 1, 1);

        -- Vérification si le numéro de lot existe dans la table LOTS
        SELECT COUNT(*) INTO v_lot_exists
        FROM LOTS
        WHERE NUMERO_LOT = 123401;
        
        -- Insertion du résultat du test dans la table TESTS_BDD
        IF v_lot_exists = 1 THEN
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test existence numéro de lot', 'Réussi');
        ELSE
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test existence numéro de lot', 'Échoué');
        END IF;
        
        -- Rollback pour annuler les modifications effectuées dans la transaction
        ROLLBACK;
    END;

    -- Démarrer une nouvelle transaction
    BEGIN
        -- Tentative d'insertion avec un numéro de lot inexistant
        BEGIN
            INSERT INTO VISITE_QUOTIDIENNE (ID_VISITE_QUOTIDIENNE, NUM_ADELI_AUXILIAIRE, NUMERO_LOT, ID_PATIENT, NUM_ADELI_MEDECIN, DATE_VISITE_QUOTIDIENNE, POIDS, PRESSION_ARTERIELLE, RYTHME_CARDIAQUE, TEMPERATURE, COMMENTAIRE, DEBUT_DE_JOURNEE, JOUR_ETUDE)
            VALUES (2, 123456, 999999, 1234, 654321, SYSDATE, 70, 120, 80, 37, 'Aucun commentaire', 1, 1);
            -- Si l'insertion réussit, afficher un message d'erreur
            INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test insertion avec numéro de lot inexistant', 'Échoué');
        EXCEPTION
            WHEN OTHERS THEN
                -- Si une erreur est déclenchée, afficher un message de succès
                INSERT INTO TESTS_BDD (NOM_TEST, RESULTAT_TEST) VALUES ('Test insertion avec numéro de lot inexistant', 'Réussi');
        END;
        -- Rollback pour annuler les modifications effectuées dans la transaction
        ROLLBACK;
    END;
END;
/
call TEST_VERIF_EXISTANCE_LOT_ADMINISTRE();




