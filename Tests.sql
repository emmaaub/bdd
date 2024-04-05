--##########################################################################################################################################################################################################
--################### TESTS TABLE SANG_ANALYSE ###########################################################################################################################################################################
--##########################################################################################################################################################################################################


--###################
--################### Test de la date de la prochaine analyse si non compl�mentaire, pas de maladies graves et tous les r�sultats sont dans les normes

CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_Sang_No_complementaire_NoMaladieGrave_GoodResults AS
    v_id_patient INT;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
BEGIN
    -- cr�er un arc et s�lectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCSang1Nom', 'TestARCSang1Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCSang1Nom';
    
    --cr�er un m�decin et s�lectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestSang1', 'MichelTestSang1');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestSang1';
    
    --cr�er un patient sans maladie grave et s�lectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestSang1Nom', 'TestSang1Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestSang1Prenom';
    
    --cr�er une analyse de sang de ce patient non compl�mentaire et tous les r�sultats dans les normes
    INSERT INTO Sang_Analyse (Id_Patient, Date_Analyse_Sang, Complementaire_Sang, Resultat_Cholesterol, Resultat_Glycemie, Resultat_Plaquettes, Resultat_4, Resultat_5, Resultat_6)
    VALUES (v_id_patient, SYSDATE, 0, 3, 3, 3, 3, 3, 3);
    --s�lectionner la date de la prochaine analyse
    SELECT Date_Prochaine_Analyse_Sang INTO v_date_prochaine_analyse FROM Sang_Analyse WHERE Id_Patient = v_id_patient;
    
    --si elle est bien �gale � j+6
    IF (v_date_prochaine_analyse = SYSDATE + 6) THEN
        ROLLBACK;
        --test r�ussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_No_complementaire_NoMaladieGrave_GoodResults', 'Succ�s');
        COMMIT;
    ELSE
        ROLLBACK;
        --sinon, test non r�ussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_No_complementaire_NoMaladieGrave_GoodResults', 'Fail');
        COMMIT;
    END IF;
END;
/

--ex�cution de la proc�dure test
CALL Test_Date_Prochaine_Analyse_Sang_No_complementaire_NoMaladieGrave_GoodResults();


--###################
--################### de la date de la prochaine analyse si compl�mentaire, pas de maladies graves et tous les r�sultats sont dans les normes
CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_Sang_Complementaire_NoMaladieGrave_GoodResults AS
    v_id_patient INT;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
BEGIN
    -- cr�er un arc et s�lectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCSang2Nom', 'TestARCSang2Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCSang2Nom';
    
    --cr�er un m�decin et s�lectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestSang2', 'MichelTestSang2');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestSang2';
    
    --cr�er un patient sans maladie grave et s�lectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestSang2Nom', 'TestSang2Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestSang2Prenom';
    
    --cr�er une analyse de sang de ce patient compl�mentaire et tous les r�sultats dans les normes
    INSERT INTO Sang_Analyse (Id_Patient, Date_Analyse_Sang, Complementaire_Sang, Resultat_Cholesterol, Resultat_Glycemie, Resultat_Plaquettes, Resultat_4, Resultat_5, Resultat_6)
    VALUES (v_id_patient, SYSDATE, 1, 3, 3, 3, 3, 3, 3);
    --s�lectionner la date de la prochaine analyse
    SELECT Date_Prochaine_Analyse_Sang INTO v_date_prochaine_analyse FROM Sang_Analyse WHERE Id_Patient = v_id_patient;
    
    --si elle est bien �gale � j+5
    IF (v_date_prochaine_analyse = SYSDATE + 5) THEN
        ROLLBACK;
        --test r�ussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_Complementaire_NoMaladieGrave_GoodResults', 'Succ�s');
        COMMIT;
    ELSE
        ROLLBACK;
        --sinon, test non r�ussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_Complementaire_NoMaladieGrave_GoodResults', 'Fail');
        COMMIT;
    END IF;
END;
/

--ex�cution de la proc�dure test
CALL Test_Date_Prochaine_Analyse_Sang_Complementaire_NoMaladieGrave_GoodResults();


--###################
--################### de la date de la prochaine analyse si compl�mentaire, 1 des maladies graves et tous les r�sultats sont dans les normes
CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_Sang_Complementaire_OUIMaladieGrave_GoodResults AS
    v_id_patient INT;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
BEGIN
    -- cr�er un arc et s�lectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCSang3Nom', 'TestARCSang3Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCSang3Nom';
    
    --cr�er un m�decin et s�lectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestSang3', 'MichelTestSang3');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestSang3';
    
    --cr�er un patient avec maladie grave et s�lectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestSang3Nom', 'TestSang3Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 1, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestSang3Prenom';
    
    --cr�er une analyse de sang de ce patient compl�mentaire et tous les r�sultats dans les normes
    INSERT INTO Sang_Analyse (Id_Patient, Date_Analyse_Sang, Complementaire_Sang, Resultat_Cholesterol, Resultat_Glycemie, Resultat_Plaquettes, Resultat_4, Resultat_5, Resultat_6)
    VALUES (v_id_patient, SYSDATE, 1, 3, 3, 3, 3, 3, 3);
    --s�lectionner la date de la prochaine analyse
    SELECT Date_Prochaine_Analyse_Sang INTO v_date_prochaine_analyse FROM Sang_Analyse WHERE Id_Patient = v_id_patient;
    
    --si elle est bien �gale � j+2
    IF (v_date_prochaine_analyse = SYSDATE + 2) THEN
        ROLLBACK;
        --test r�ussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_Complementaire_OUIMaladieGrave_GoodResults', 'Succ�s');
        COMMIT;
    ELSE
        ROLLBACK;
        --sinon, test non r�ussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_Complementaire_OUIMaladieGrave_GoodResults', 'Fail');
        COMMIT;
    END IF;
END;
/

--ex�cution de la proc�dure test
CALL Test_Date_Prochaine_Analyse_Sang_Complementaire_OUIMaladieGrave_GoodResults();

--###################
--################### Test de la date de la prochaine analyse si non compl�mentaire, 1 des maladies graves et tous les r�sultats sont dans les normes
CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_Sang_NoComplementaire_MaladieGrave_GoodResults AS
    v_id_patient INT;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
BEGIN
    -- cr�er un arc et s�lectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCSang3Nom', 'TestARCSang3Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCSang3Nom';
    
    --cr�er un m�decin et s�lectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestSang3', 'MichelTestSang3');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestSang3';
    
    --cr�er un patient avec maladie grave et s�lectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestSang3Nom', 'TestSang3Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 1, 1, 1, 0, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestSang3Prenom';
    
    --cr�er une analyse de sang de ce patient non compl�mentaire et tous les r�sultats dans les normes
    INSERT INTO Sang_Analyse (Id_Patient, Date_Analyse_Sang, Complementaire_Sang, Resultat_Cholesterol, Resultat_Glycemie, Resultat_Plaquettes, Resultat_4, Resultat_5, Resultat_6)
    VALUES (v_id_patient, SYSDATE, 0, 3, 3, 3, 3, 3, 3);
    --s�lectionner la date de la prochaine analyse
    SELECT Date_Prochaine_Analyse_Sang INTO v_date_prochaine_analyse FROM Sang_Analyse WHERE Id_Patient = v_id_patient;
    
    --si elle est bien �gale � j+3
    IF (v_date_prochaine_analyse = SYSDATE + 3) THEN
        ROLLBACK;
        --test r�ussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_NoComplementaire_MaladieGrave_GoodResults', 'Succ�s');
        COMMIT;
    ELSE    
        ROLLBACK;
        --sinon, test non r�ussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_NoComplementaire_MaladieGrave_GoodResults', 'Fail');
        COMMIT;
        
    END IF;
END;
/

--ex�cution de la proc�dure test
CALL Test_Date_Prochaine_Analyse_Sang_NoComplementaire_MaladieGrave_GoodResults();

--###################
--################### Test de la date de la prochaine analyse si non compl�mentaire, pas de maladies graves mais 3 r�sultats sont hors normes
CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_Sang_NoComplementaire_NoMaladieGrave_BadResults AS
    v_id_patient INT;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
BEGIN
    -- cr�er un arc et s�lectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCSang3Nom', 'TestARCSang3Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCSang3Nom';
    
    --cr�er un m�decin et s�lectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestSang3', 'MichelTestSang3');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestSang3';
    
    --cr�er un patient avec maladie grave et s�lectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestSang3Nom', 'TestSang3Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestSang3Prenom';
    
    --cr�er une analyse de sang de ce patient non compl�mentaire et tous les r�sultats dans les normes
    INSERT INTO Sang_Analyse (Id_Patient, Date_Analyse_Sang, Complementaire_Sang, Resultat_Cholesterol, Resultat_Glycemie, Resultat_Plaquettes, Resultat_4, Resultat_5, Resultat_6)
    VALUES (v_id_patient, SYSDATE, 0, 3, 3, 3, 1, 1, 1);
    --s�lectionner la date de la prochaine analyse
    SELECT Date_Prochaine_Analyse_Sang INTO v_date_prochaine_analyse FROM Sang_Analyse WHERE Id_Patient = v_id_patient;
    
    --si elle est bien �gale � j+3
    IF (v_date_prochaine_analyse = SYSDATE + 0.21) THEN
        ROLLBACK;
        --test r�ussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_NoComplementaire_NoMaladieGrave_BadResults', 'Succ�s');
        COMMIT;
    ELSE
        ROLLBACK;
        --sinon, test non r�ussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_NoComplementaire_NoMaladieGrave_BadResults', 'Fail');
        COMMIT;
    END IF;
END;
/

--ex�cution de la proc�dure test
CALL Test_Date_Prochaine_Analyse_Sang_NoComplementaire_NoMaladieGrave_BadResults();


--##########################################################################################################################################################################################################
--################### TESTS TABLE PCR COVID ANALYSE ###########################################################################################################################################################################
--##########################################################################################################################################################################################################


--###################
--################### Test de la date de la prochaine analyse de pcr covid si r�sultat n�gatif et sans maladie grave

CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_PCR_ResultatNeg_NoMaladieGrave AS
    v_id_patient INT;
    v_date_analyse date;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
    v_date_fin_inclusion date;
    v_motif_fin_inclusion Patient.Motif_Fin_Inclusion%TYPE;
BEGIN
    -- cr�er un arc et s�lectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCPCR3Nom', 'TestARCPCR3Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCPCR3Nom';
    
    --cr�er un m�decin et s�lectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestPCR3', 'MichelTestPCR3');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestPCR3';
    
    --cr�er un patient avec maladie grave et s�lectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestPCR3Nom', 'TestPCR3Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestPCR3Prenom';
    
    --cr�er une analyse pcr covid avec un r�sultat n�gatif et non compl�mentaire
    INSERT INTO PCR_Covid_Analyse (Id_Patient, Date_Analyse_PCR_Covid, Resultat_PCR_Covid)
    VALUES (v_id_patient, SYSDATE, 'Negatif');
    --s�lectionner la date de prochaine analyse
    SELECT Date_Prochaine_Analyse_PCR_Cov INTO v_date_prochaine_analyse FROM PCR_Covid_Analyse WHERE Id_Patient = v_id_patient;
    
    SELECT Date_Fin_Inclusion, Motif_Fin_Inclusion INTO v_date_fin_inclusion, v_motif_fin_inclusion FROM Patient WHERE Id_Patient = v_id_patient;
    
    
    if (v_date_prochaine_analyse = SYSDATE + 1 AND v_date_fin_inclusion = null AND v_motif_fin_inclusion = null) THEN
        ROLLBACK;
        --test r�ussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_PCR_ResultatNeg_NoMaladieGrave', 'Succ�s');
        COMMIT;
    else 
        RAISE_APPLICATION_ERROR(-20020, 'Not the good next day of PCR test for ' || v_id_patient);
        --test non r�ussi
        ROLLBACK;
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_PCR_ResultatNeg_NoMaladieGrave', 'Fail');
        COMMIT;
    end if;
END Test_Date_Prochaine_Analyse_PCR_ResultatNeg_NoMaladieGrave;
/

call Test_Date_Prochaine_Analyse_PCR_ResultatNeg_NoMaladieGrave();

--###################
--################### Test de la date de la prochaine analyse de pcr covid si r�sultat positif 

CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_PCR_ResultatPos AS
    v_id_patient INT;
    v_date_analyse date;
    v_date_prochaine_analyse DATE;
    v_id_arc int;
    v_num_adeli_medecin int;
    v_date_fin_inclusion date;
    v_motif_fin_inclusion Patient.Motif_Fin_Inclusion%TYPE;
    
BEGIN
    -- cr�er un arc et s�lectionner son id
    INSERT INTO ARC (Nom_Arc, Prenom_ARC) 
    VALUES ('TestARCPCR3Nom', 'TestARCPCR3Prenom');
    SELECT Id_ARC INTO v_id_arc FROM  ARC WHERE Nom_ARC = 'TestARCPCR3Nom';
    
    --cr�er un m�decin et s�lectionner son id
    INSERT INTO Medecin (Num_ADELI_Medecin, Id_ARC, Specialite_Medecin, Cohorte_Referent, Nom_Medecin, Prenom_Medecin) 
    VALUES (123456789, v_id_arc, 'Generaliste', 1, 'ArmondTestPCR3', 'MichelTestPCR3');
    SELECT Num_ADELI_Medecin INTO v_num_adeli_medecin FROM Medecin WHERE Nom_Medecin = 'ArmondTestPCR3';
    
    --cr�er un patient avec maladie grave et s�lectionner son id
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (v_num_adeli_medecin, 'TestPCR3Nom', 'TestPCR3Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestPCR3Prenom';
    
    --cr�er une analyse pcr covid avec un r�sultat n�gatif et non compl�mentaire
    INSERT INTO PCR_Covid_Analyse (Id_Patient, Date_Analyse_PCR_Covid, Resultat_PCR_Covid)
    VALUES (v_id_patient, SYSDATE, 'Variant alpha detecte');
    --s�lectionner la date de prochaine analyse et la date de l'analyse
    SELECT Date_Analyse_PCR_Covid, Date_Prochaine_Analyse_PCR_Cov INTO v_date_analyse, v_date_prochaine_analyse FROM PCR_Covid_Analyse WHERE Id_Patient = v_id_patient;
    --s�lectionner la date et le motif de fin inclusion du patient
    SELECT Date_Fin_Inclusion, Motif_Fin_Inclusion INTO v_date_fin_inclusion, v_motif_fin_inclusion FROM Patient WHERE Id_Patient = v_id_patient;
    
    
    if (v_date_prochaine_analyse = SYSDATE AND v_date_fin_inclusion = v_date_analyse AND v_motif_fin_inclusion = null) THEN
        ROLLBACK;
        --test r�ussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_PCR_ResultatPos', 'Succ�s');
        COMMIT;
    else
        RAISE_APPLICATION_ERROR(-20030, 'Not the good next day of PCR test for' || v_id_patient);
        ROLLBACK;
        --test non r�ussi
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_PCR_ResultatPos', 'Fail');
        COMMIT;
    end if;
END Test_Date_Prochaine_Analyse_PCR_ResultatPos;
/

call Test_Date_Prochaine_Analyse_PCR_ResultatPos();
