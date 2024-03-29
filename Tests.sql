CREATE OR REPLACE PROCEDURE Test_Date_Prochaine_Analyse_Sang_NoMaladieGrave_GoodResults AS
    v_id_patient INT;
    v_date_prochaine_analyse DATE;
BEGIN
    INSERT INTO Patient (Num_ADELI_Medecin, Nom_Patient, Prenom_Patient, Sexe_Patient, DDN_Patient, Num_Secu_Patient, Menopause, VaccinationGrippe, VaccinationCovid, Hypertension, Obesite, Type_Groupe, Type_Sous_Groupe)
    VALUES (123456788, 'TestSang1Nom', 'TestSang1Prenom', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 202115936027333, 0, 1, 1, 0, 0, 'PP', 2);
    
    SELECT Id_Patient INTO v_id_patient FROM Patient WHERE Prenom_Patient = 'TestSang1Prenom';
    
    INSERT INTO Sang_Analyse (Id_Patient, Date_Analyse_Sang, Complementaire_Sang, Resultat_Cholesterol, Resultat_Glycemie, Resultat_Plaquettes, Resultat_4, Resultat_5, Resultat_6)
    VALUES (v_id_patient, SYSDATE, 0, 3, 3, 3, 3, 3, 3);
    
    SELECT Date_Prochaine_Analyse_Sang INTO v_date_prochaine_analyse FROM Sang_Analyse WHERE Id_Patient = v_id_patient;
    
    IF (v_date_prochaine_analyse = SYSDATE + 6) THEN
        ROLLBACK;
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_NoMaladieGrave_GoodResults', 'Succès');
        COMMIT;
    ELSE
        ROLLBACK;
        INSERT INTO Tests_BDD (Nom_Test, Resultat_Test) VALUES ('Test_Date_Prochaine_Analyse_Sang_NoMaladieGrave_GoodResults', 'Fail');
        COMMIT;
    END IF;
END;
/
CALL Test_Date_Prochaine_Analyse_Sang_NoMaladieGrave_GoodResults();