--############################################################################
--###################PEUPLEMENT#############################################
--############################################################################

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


--tests commentaire


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
CALL Peuplement_patient('Richard', 'Marie', 'M', TO_DATE('2002-01-19', 'YYYY-MM-DD'), 101022652352144, 1, 1, 1, 0, 0, 'PP', 3);


--############################################################################
--###################ANALYSE SANG#############################################
--############################################################################

--PROCEDURE DE VERIFICATION DES CONCENTRATIONS SANGUINES

CREATE OR REPLACE PROCEDURE verifier_concentration (
    p_concentration_chol IN NUMBER,
    p_concentration_gly in number,
    p_concentration_plaq in number,
    p_concentration_4 in number,
    p_concentration_5 in number,
    p_concentration_6 in number,
    p_normal_chol_1 IN NUMBER,
    p_normal_chol_2 IN NUMBER,
    p_normal_gly_1 IN NUMBER,
    p_normal_gly_2 IN NUMBER,
    p_normal_plaq_1 IN NUMBER,
    p_normal_plaq_2 IN NUMBER,
    p_normal_4_1 IN NUMBER,
    p_normal_4_2 IN NUMBER,
    p_normal_5_1 IN NUMBER,
    p_normal_5_2 IN NUMBER,
    p_normal_6_1 IN NUMBER,
    p_normal_6_2 IN NUMBER,
    p_anormal_chol_1 IN NUMBER,
    p_anormal_chol_2 IN NUMBER,
    p_anormal_gly_1 IN NUMBER,
    p_anormal_gly_2 IN NUMBER,
    p_anormal_plaq_1 IN NUMBER,
    p_anormal_plaq_2 IN NUMBER,
    p_anormal_4_1 IN NUMBER,
    p_anormal_4_2 IN NUMBER,
    p_anormal_5_1 IN NUMBER,
    p_anormal_5_2 IN NUMBER,
    p_anormal_6_1 IN NUMBER,
    p_anormal_6_2 IN NUMBER,
    p_id_patient IN NUMBER
)
AS
    v_etat VARCHAR2(50);
    v_local_date_analyse DATE;
    v_nb_analyse_hors_norme NUMBER := 0;
    v_complementaire INTEGER;
    v_hypertension INTEGER; 
    v_obesite INTEGER;
    v_menopause INTEGER;
BEGIN
    --if p_concentration_chol >= p_normal_chol_1 AND p_concentration_chol <= p_normal_chol_2 THEN
        
    if (p_concentration_chol < p_normal_chol_1 OR p_concentration_chol > p_normal_chol_2) AND 
       (p_concentration_chol > p_anormal_chol_1 OR p_concentration_chol < p_anormal_chol_2) THEN
        v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
    elsif (p_concentration_chol <= p_anormal_chol_1 OR p_concentration_chol >= p_anormal_chol_2) THEN
        v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
    end if;
    
    
    
    if (p_concentration_gly < p_normal_gly_1 OR p_concentration_gly > p_normal_gly_2) AND 
       (p_concentration_gly > p_anormal_gly_1 OR p_concentration_gly < p_anormal_gly_2) THEN
        v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
    elsif (p_concentration_gly <= p_anormal_gly_1 OR p_concentration_gly >= p_anormal_gly_2) THEN
        v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
    end if;
    
    if (p_concentration_plaq < p_normal_plaq_1 OR p_concentration_plaq > p_normal_plaq_2) AND 
       (p_concentration_plaq > p_anormal_plaq_1 OR p_concentration_plaq < p_anormal_plaq_2) THEN
        v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
    elsif (p_concentration_plaq <= p_anormal_plaq_1 OR p_concentration_plaq >= p_anormal_plaq_2) THEN
        v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
    end if;
    
    if (p_concentration_4 < p_normal_4_1 OR p_concentration_4 > p_normal_4_2) AND 
       (p_concentration_4 > p_anormal_4_1 OR p_concentration_4 < p_anormal_4_2) THEN
        v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
    elsif (p_concentration_4 <= p_anormal_4_1 OR p_concentration_4 >= p_anormal_4_2) THEN
        v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
    end if;  

    if (p_concentration_5 < p_normal_5_1 OR p_concentration_5 > p_normal_5_2) AND 
    (p_concentration_5 > p_anormal_5_1 OR p_concentration_5 < p_anormal_5_2) THEN
        v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
    elsif (p_concentration_5 <= p_anormal_5_1 OR p_concentration_5 >= p_anormal_5_2) THEN
        v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
    end if;
    
    if (p_concentration_6 < p_normal_6_1 OR p_concentration_6 > p_normal_6_2) AND 
    (p_concentration_6 > p_anormal_6_1 OR p_concentration_6 < p_anormal_6_2) THEN
        v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
    elsif (p_concentration_6 <= p_anormal_6_1 OR p_concentration_6 >= p_anormal_6_2) THEN
        v_nb_analyse_hors_norme := v_nb_analyse_hors_norme + 1;
    end if;


    SELECT (Date_Analyse_Sang) INTO v_local_date_analyse FROM Sang_Analyse 
    WHERE Date_Analyse_Sang = SYSDATE AND Id_Patient = p_id_patient;

    if v_nb_analyse_hors_norme >= 3 THEN 
        UPDATE Sang_Analyse 
        SET Date_Prochaine_Analyse_Sang = v_local_date_analyse + 0.21
        WHERE Date_Analyse_Sang = SYSDATE AND Id_Patient = p_id_patient;
    else
            SELECT Complementaire_Sang INTO v_complementaire 
            FROM Sang_Analyse 
            WHERE Id_Patient = p_id_Patient AND Date_Analyse_Sang = SYSDATE;
            
            SELECT Hypertension, Obesite, Menopause INTO v_hypertension, v_obesite, v_menopause 
            FROM Patient 
            WHERE Id_Patient = p_id_Patient;
            
            
        if (v_complementaire = 1) AND (v_hypertension=1 OR v_obesite=1 OR v_menopause=1) then
            UPDATE Sang_Analyse 
            SET Date_Prochaine_Analyse_Sang = v_local_date_analyse + 5
            WHERE Date_Analyse_Sang = SYSDATE AND Id_Patient = p_id_patient;
        elsif (v_complementaire = 0) AND (v_hypertension=1 OR v_obesite=1 OR v_menopause=1) then
            UPDATE Sang_Analyse 
            SET Date_Prochaine_Analyse_Sang = v_local_date_analyse + 3
            WHERE Date_Analyse_Sang = SYSDATE AND Id_Patient = p_id_patient;
        else
            UPDATE Sang_Analyse 
            SET Date_Prochaine_Analyse_Sang = v_local_date_analyse + 6 
            WHERE Date_Analyse_Sang = SYSDATE AND Id_Patient = p_id_patient;
        end if;
    end if;
    
    COMMIT;
END;
/

--PEUPLEMENT
    
CREATE OR REPLACE PROCEDURE Peuplement_Analyse_Sang(
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
    PIDPatient INT;
BEGIN
    SELECT Id_Patient INTO PIDPatient FROM Patient WHERE Id_Patient = 1;
    
    INSERT INTO Sang_Analyse (Id_Patient, Date_Analyse_Sang, Complementaire_Sang, Resultat_Cholesterol, Resultat_Glycemie, Resultat_Plaquettes, Resultat_4, Resultat_5, Resultat_6) 
    VALUES (PIDPatient, PDate_Analyse, Pcomplementaire, PresChol, PresGly, PresPlaq, Pres4, Pres5, Pres6);
    
    verifier_concentration(PresChol, PresGly, PresPlaq, Pres4, Pres5, Pres6, 2, 5, 2, 5, 2, 5, 2, 5, 2, 5, 2, 5, 0, 7, 0, 7, 0, 7, 0, 7, 0, 7, 0, 7, PIDPatient);
    
    COMMIT;
END Peuplement_Analyse_Sang;
/

ALTER TRIGGER COMPOUNDINSERTTRIGGER_SANG_ANA DISABLE;
ALTER TRIGGER COMPOUNDUPDATETRIGGER_SANG_ANA DISABLE;

CALL Peuplement_Analyse_Sang (SYSDATE, 1, 3, 3, 3, 3, 3, 3);

