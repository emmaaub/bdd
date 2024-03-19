-- Déclaration de package type
-- tentative de push A VOIR SI CELA FONCTIONNE  &jahahahaha
create or replace package PDTypes  
as
    TYPE ref_cursor IS REF CURSOR;
end;

-- Déclaration du package d'intégrité
create or replace package IntegrityPackage AS
 procedure InitNestLevel;
 function GetNestLevel return number;
 procedure NextNestLevel;
 procedure PreviousNestLevel;
 end IntegrityPackage;
/

-- Définition du package d'intégrité
create or replace package body IntegrityPackage AS
 NestLevel number;

-- Procédure d'initialisation du niveau de trigger
 procedure InitNestLevel is
 begin
 NestLevel := 0;
 end;


-- Fonction retournant le niveau d'imbrication
 function GetNestLevel return number is
 begin
 if NestLevel is null then
     NestLevel := 0;
 end if;
 return(NestLevel);
 end;

-- Procédure d'augmentation du niveau de trigger
 procedure NextNestLevel is
 begin
 if NestLevel is null then
     NestLevel := 0;
 end if;
 NestLevel := NestLevel + 1;
 end;

-- Procédure de diminution du niveau de trigger
 procedure PreviousNestLevel is
 begin
 NestLevel := NestLevel - 1;
 end;

 end IntegrityPackage;
/


drop trigger COMPOUNDDELETETRIGGER_ACTE_MED
/

drop trigger COMPOUNDINSERTTRIGGER_ACTE_MED
/

drop trigger COMPOUNDUPDATETRIGGER_ACTE_MED
/

drop trigger TIB_ACTE_MEDICAL_CARNET_MEDICA
/

drop trigger COMPOUNDDELETETRIGGER_ARC
/

drop trigger COMPOUNDINSERTTRIGGER_ARC
/

drop trigger COMPOUNDUPDATETRIGGER_ARC
/

drop trigger TIB_ARC
/

drop trigger COMPOUNDDELETETRIGGER_CENTRE_E
/

drop trigger COMPOUNDINSERTTRIGGER_CENTRE_E
/

drop trigger COMPOUNDUPDATETRIGGER_CENTRE_E
/

drop trigger TIB_CENTRE_EC
/

drop trigger COMPOUNDDELETETRIGGER_EFFORT_A
/

drop trigger COMPOUNDINSERTTRIGGER_EFFORT_A
/

drop trigger COMPOUNDUPDATETRIGGER_EFFORT_A
/

drop trigger TIB_EFFORT_ANALYSE
/

drop trigger COMPOUNDDELETETRIGGER_LIGNE_CA
/

drop trigger COMPOUNDINSERTTRIGGER_LIGNE_CA
/

drop trigger COMPOUNDUPDATETRIGGER_LIGNE_CA
/

drop trigger TIB_LIGNE_CARNET_MEDICAL
/

drop trigger COMPOUNDDELETETRIGGER_MEDECIN
/

drop trigger COMPOUNDINSERTTRIGGER_MEDECIN
/

drop trigger COMPOUNDUPDATETRIGGER_MEDECIN
/

drop trigger COMPOUNDDELETETRIGGER_PATIENT
/

drop trigger COMPOUNDINSERTTRIGGER_PATIENT
/

drop trigger COMPOUNDUPDATETRIGGER_PATIENT
/

drop trigger TIB_PATIENT
/

drop trigger COMPOUNDDELETETRIGGER_PCR_COVI
/

drop trigger COMPOUNDINSERTTRIGGER_PCR_COVI
/

drop trigger COMPOUNDUPDATETRIGGER_PCR_COVI
/

drop trigger TIB_PCR_COVID_ANALYSE
/

drop trigger COMPOUNDDELETETRIGGER_SANG_ANA
/

drop trigger COMPOUNDINSERTTRIGGER_SANG_ANA
/

drop trigger COMPOUNDUPDATETRIGGER_SANG_ANA
/

drop trigger TIB_SANG_ANALYSE
/

drop trigger COMPOUNDDELETETRIGGER_TRAITEME
/

drop trigger COMPOUNDINSERTTRIGGER_TRAITEME
/

drop trigger COMPOUNDUPDATETRIGGER_TRAITEME
/

drop trigger TIB_TRAITEMENT_PATHOLOGIE_CARN
/

drop trigger COMPOUNDDELETETRIGGER_VISITE_Q
/

drop trigger COMPOUNDINSERTTRIGGER_VISITE_Q
/

drop trigger COMPOUNDUPDATETRIGGER_VISITE_Q
/

drop trigger TIB_VISITE_QUOTIDIENNE
/

alter table ACTE_MEDICAL_CARNET_MEDICAL
   drop constraint FK_ACTE_MED_TRAITER_P_LIGNE_CA
/

alter table ADMINISTRATION_LOT
   drop constraint FK_ADMINIST_ADMINISTR_VISITE_Q
/

alter table ADMINISTRATION_LOT
   drop constraint FK_ADMINIST_ADMINISTR_LOTS
/

alter table ARC
   drop constraint FK_ARC_ARCCENTRE_CENTRE_E
/

alter table AUXILIAIRE
   drop constraint FK_AUXILIAI_AUXILIAIR_CENTRE_E
/

alter table AUXILIAIRE_VISITE_TRACABILITE
   drop constraint FK_AUXILIAI_AUXILIAIR_AUXILIAI
/

alter table AUXILIAIRE_VISITE_TRACABILITE
   drop constraint FK_AUXILIAI_AUXILIAIR_VISITE_Q
/

alter table CENTRE_EC
   drop constraint FK_CENTRE_E_ARCCENTRE_ARC
/

alter table EEG_ANALYSE
   drop constraint FK_EEG_ANAL_ANALYSE_T_PATIENT
/

alter table EFFORT_ANALYSE
   drop constraint FK_EFFORT_A_ANALYSE_T_PATIENT
/

alter table LIGNE_CARNET_MEDICAL
   drop constraint FK_LIGNE_CA_SUIVI_PAT_PATIENT
/

alter table MEDECIN
   drop constraint FK_MEDECIN_MEDECINCE_CENTRE_E
/

alter table MEDECIN
   drop constraint FK_MEDECIN_SUPERVISI_ARC
/

alter table PATIENT
   drop constraint FK_PATIENT_SUPERVISI_MEDECIN
/

alter table PATIENTCENTRE
   drop constraint FK_PATIENTC_PATIENTCE_CENTRE_E
/

alter table PATIENTCENTRE
   drop constraint FK_PATIENTC_PATIENTCE_PATIENT
/

alter table PCR_COVID_ANALYSE
   drop constraint FK_PCR_COVI_ANALYSE_P_PATIENT
/

alter table SANG_ANALYSE
   drop constraint FK_SANG_ANA_ANALYSE_S_PATIENT
/

alter table TRACABILITE_MEDECIN_VISITE
   drop constraint FK_TRACABIL_TRACABILI_MEDECIN
/

alter table TRACABILITE_MEDECIN_VISITE
   drop constraint FK_TRACABIL_TRACABILI_VISITE_Q
/

alter table TRAITEMENT_PATHOLOGIE_CARNET_M
   drop constraint FK_TRAITEME_MEDICAMEN_LIGNE_CA
/

alter table VISITE_QUOTIDIENNE
   drop constraint FK_VISITE_Q_VISITE_PA_PATIENT
/

drop index TRAITER_PAR_ACTE_FK
/

drop table ACTE_MEDICAL_CARNET_MEDICAL cascade constraints
/

drop index ADMINISTRATION_LOT2_FK
/

drop index ADMINISTRATION_LOT_FK
/

drop table ADMINISTRATION_LOT cascade constraints
/

drop index CENTRE_ARC_FK
/

drop table ARC cascade constraints
/

drop index CENTRE_AUXILIAIRE_FK
/

drop table AUXILIAIRE cascade constraints
/

drop index TRACABILITE_AUXILIAIRE_VISITE2
/

drop index TRACABILITE_AUXILIAIRE_VISITE_
/

drop table AUXILIAIRE_VISITE_TRACABILITE cascade constraints
/

drop index CENTRE_ARC2_FK
/

drop table CENTRE_EC cascade constraints
/

drop index ANALYSE_TEST_EEG_FK
/

drop table EEG_ANALYSE cascade constraints
/

drop index ANALYSE_TEST_EFFORT_FK
/

drop table EFFORT_ANALYSE cascade constraints
/

drop index SUIVI_PATIENT_FK
/

drop table LIGNE_CARNET_MEDICAL cascade constraints
/

drop table LOTS cascade constraints
/

drop index CENTRE_MEDECIN_FK
/

drop index SUPERVISION_MEDECIN_FK
/

drop table MEDECIN cascade constraints
/

drop index SUPERVISION_PATIENT_FK
/

drop table PATIENT cascade constraints
/

drop index CENTRE_PATIENT2_FK
/

drop index CENTRE_PATIENT_FK
/

drop table PATIENTCENTRE cascade constraints
/

drop index ANALYSE_PCR_FK
/

drop table PCR_COVID_ANALYSE cascade constraints
/

drop index ANALYSE_EC_FK
/

drop table SANG_ANALYSE cascade constraints
/

drop index TRACABILITE_MEDECIN_VISITE2_FK
/

drop index TRACABILITE_MEDECIN_VISITE_FK
/

drop table TRACABILITE_MEDECIN_VISITE cascade constraints
/

drop index TRAITER_PATHOLOGIE_FK
/

drop table TRAITEMENT_PATHOLOGIE_CARNET_M cascade constraints
/

drop index VISITE_PATIENT_FK
/

drop table VISITE_QUOTIDIENNE cascade constraints
/

drop sequence AI_ACTE_MEDICAL
/

drop sequence AI_ANALYSE_EFFORT
/

drop sequence AI_ANALYSE_PCR_COVID
/

drop sequence AI_ANALYSE_SANG
/

drop sequence AI_ARC
/

drop sequence AI_CENTRE_EC
/

drop sequence AI_ID_CARNET_MEDICAL
/

drop sequence AI_ID_TRAITEMENT
/

drop sequence AI_PATIENT
/

drop sequence AI_VISITE_QUOTIDIENNE
/

create sequence AI_ACTE_MEDICAL
/

create sequence AI_ANALYSE_EFFORT
/

create sequence AI_ANALYSE_PCR_COVID
/

create sequence AI_ANALYSE_SANG
/

create sequence AI_ARC
/

create sequence AI_CENTRE_EC
/

create sequence AI_ID_CARNET_MEDICAL
/

create sequence AI_ID_TRAITEMENT
/

create sequence AI_PATIENT
increment by 1
start with 1
 nomaxvalue
 nominvalue
 nocache
order
/

create sequence AI_VISITE_QUOTIDIENNE
/

/*==============================================================*/
/* Table : ACTE_MEDICAL_CARNET_MEDICAL                          */
/*==============================================================*/
create table ACTE_MEDICAL_CARNET_MEDICAL (
   ID_ACTE_MEDICAL      NUMBER                not null,
   ID_CARNET_MEDICAL    NUMBER                not null,
   REGULIER             NUMBER                not null,
   NOM_ACTE_MEDICAL     VARCHAR2(1024)        not null,
   DATE_ACTE_MEDICAL    DATE                  not null,
   FREQUENCE_ACTE_MEDICAL NUMBER,
   constraint PK_ACTE_MEDICAL_CARNET_MEDICAL primary key (ID_ACTE_MEDICAL)
)
/

/*==============================================================*/
/* Index : TRAITER_PAR_ACTE_FK                                  */
/*==============================================================*/
create index TRAITER_PAR_ACTE_FK on ACTE_MEDICAL_CARNET_MEDICAL (
   ID_CARNET_MEDICAL ASC
)
/

/*==============================================================*/
/* Table : ADMINISTRATION_LOT                                   */
/*==============================================================*/
create table ADMINISTRATION_LOT (
   ID_VISITE_QUOTIDIENNE NUMBER                not null,
   NUMERO_LOT           NUMBER(6)             not null,
   constraint PK_ADMINISTRATION_LOT primary key (ID_VISITE_QUOTIDIENNE, NUMERO_LOT)
)
/

/*==============================================================*/
/* Index : ADMINISTRATION_LOT_FK                                */
/*==============================================================*/
create index ADMINISTRATION_LOT_FK on ADMINISTRATION_LOT (
   ID_VISITE_QUOTIDIENNE ASC
)
/

/*==============================================================*/
/* Index : ADMINISTRATION_LOT2_FK                               */
/*==============================================================*/
create index ADMINISTRATION_LOT2_FK on ADMINISTRATION_LOT (
   NUMERO_LOT ASC
)
/

/*==============================================================*/
/* Table : ARC                                                  */
/*==============================================================*/
create table ARC (
   ID_ARC               NUMBER                not null,
   ID_CENTRE_EC         NUMBER,
   NOM_ARC              VARCHAR2(1024)        not null,
   PRENOM_ARC           VARCHAR2(1024)        not null,
   constraint PK_ARC primary key (ID_ARC)
)
/

/*==============================================================*/
/* Index : CENTRE_ARC_FK                                        */
/*==============================================================*/
create index CENTRE_ARC_FK on ARC (
   ID_CENTRE_EC ASC
)
/

/*==============================================================*/
/* Table : AUXILIAIRE                                           */
/*==============================================================*/
create table AUXILIAIRE (
   NUM_ADELI_AUXILIAIRE NUMBER                not null,
   ID_CENTRE_EC         NUMBER,
   SPECIALITE_AUXILIAIRE VARCHAR2(1024)        not null,
   NOM_AUXILIAIRE       VARCHAR2(1024)        not null,
   PRENOM_AUXILIAIRE    VARCHAR2(1024)        not null,
   constraint PK_AUXILIAIRE primary key (NUM_ADELI_AUXILIAIRE)
)
/

/*==============================================================*/
/* Index : CENTRE_AUXILIAIRE_FK                                 */
/*==============================================================*/
create index CENTRE_AUXILIAIRE_FK on AUXILIAIRE (
   ID_CENTRE_EC ASC
)
/

/*==============================================================*/
/* Table : AUXILIAIRE_VISITE_TRACABILITE                        */
/*==============================================================*/
create table AUXILIAIRE_VISITE_TRACABILITE (
   NUM_ADELI_AUXILIAIRE NUMBER                not null,
   ID_VISITE_QUOTIDIENNE NUMBER                not null,
   constraint PK_AUXILIAIRE_VISITE_TRACABILI primary key (NUM_ADELI_AUXILIAIRE, ID_VISITE_QUOTIDIENNE)
)
/

/*==============================================================*/
/* Index : TRACABILITE_AUXILIAIRE_VISITE_                       */
/*==============================================================*/
create index TRACABILITE_AUXILIAIRE_VISITE_ on AUXILIAIRE_VISITE_TRACABILITE (
   NUM_ADELI_AUXILIAIRE ASC
)
/

/*==============================================================*/
/* Index : TRACABILITE_AUXILIAIRE_VISITE2                       */
/*==============================================================*/
create index TRACABILITE_AUXILIAIRE_VISITE2 on AUXILIAIRE_VISITE_TRACABILITE (
   ID_VISITE_QUOTIDIENNE ASC
)
/

/*==============================================================*/
/* Table : CENTRE_EC                                            */
/*==============================================================*/
create table CENTRE_EC (
   ID_CENTRE_EC         NUMBER                not null,
   constraint PK_CENTRE_EC primary key (ID_CENTRE_EC)
)
/



/*==============================================================*/
/* Table : EEG_ANALYSE                                          */
/*==============================================================*/
create table EEG_ANALYSE (
   ID_ANALYSE_EEG       NUMBER                not null,
   ID_PATIENT           NUMBER                not null,
   DATE_ANALYSE_EEG     DATE                  not null,
   DATE_PROCHAINE_ANALYSE_EEG DATE,
   COMPLEMENTAIRE_EEG   NUMBER                not null
      constraint CKC_COMPLEMENTAIRE_EE_EEG_ANAL check (COMPLEMENTAIRE_EEG in (0,1)),
   RESULTAT_EEG         NUMBER,
   constraint PK_EEG_ANALYSE primary key (ID_ANALYSE_EEG)
)
/

/*==============================================================*/
/* Index : ANALYSE_TEST_EEG_FK                                  */
/*==============================================================*/
create index ANALYSE_TEST_EEG_FK on EEG_ANALYSE (
   ID_PATIENT ASC
)
/

/*==============================================================*/
/* Table : EFFORT_ANALYSE                                       */
/*==============================================================*/
create table EFFORT_ANALYSE (
   ID_ANALYSE_EFFORT    NUMBER                not null,
   ID_PATIENT           NUMBER                not null,
   DATE_ANALYSE_EFFORT  DATE                  not null,
   DATE_PROCHAINE_ANALYSE_EFFORT DATE,
   COMPLEMENTAIRE_EFFORT NUMBER                not null
      constraint CKC_COMPLEMENTAIRE_EF_EFFORT_A check (COMPLEMENTAIRE_EFFORT in (0,1)),
   RESULAT_RYTHME_CARDIAQUE_AVANT NUMBER,
   RESULTAT_RYTHME_CARDIAQUE_APRE NUMBER,
   RESULTAT_RYTHME_CARDIAQUE_UNEM NUMBER,
   constraint PK_EFFORT_ANALYSE primary key (ID_ANALYSE_EFFORT)
)
/

/*==============================================================*/
/* Index : ANALYSE_TEST_EFFORT_FK                               */
/*==============================================================*/
create index ANALYSE_TEST_EFFORT_FK on EFFORT_ANALYSE (
   ID_PATIENT ASC
)
/

/*==============================================================*/
/* Table : LIGNE_CARNET_MEDICAL                                 */
/*==============================================================*/
create table LIGNE_CARNET_MEDICAL (
   ID_CARNET_MEDICAL    NUMBER                not null,
   ID_PATIENT           NUMBER                not null,
   NOM_PATHOLOGIE       VARCHAR2(1024)        not null,
   DATE_DEBUT_PATHOLOGIE DATE                  not null,
   DATE_FIN_PATHOLOGIE  DATE,
   GRAVITE              NUMBER                not null,
   constraint PK_LIGNE_CARNET_MEDICAL primary key (ID_CARNET_MEDICAL)
)
/

/*==============================================================*/
/* Index : SUIVI_PATIENT_FK                                     */
/*==============================================================*/
create index SUIVI_PATIENT_FK on LIGNE_CARNET_MEDICAL (
   ID_PATIENT ASC
)
/

/*==============================================================*/
/* Table : LOTS                                                 */
/*==============================================================*/
create table LOTS (
   NUMERO_LOT           NUMBER(6)             not null,
   TYPE_LOT             VARCHAR2(1024)        not null,
   constraint PK_LOTS primary key (NUMERO_LOT)
)
/

/*==============================================================*/
/* Table : MEDECIN                                              */
/*==============================================================*/
create table MEDECIN (
   NUM_ADELI_MEDECIN    NUMBER                not null,
   ID_ARC               NUMBER                not null,
   ID_CENTRE_EC         NUMBER,
   SPECIALITE_MEDECIN   VARCHAR2(1024)        not null,
   COHORTE_REFERENT     NUMBER                not null,
   NOM_MEDECIN          VARCHAR2(1024)        not null,
   PRENOM_MEDECIN       VARCHAR2(1024)        not null,
   constraint PK_MEDECIN primary key (NUM_ADELI_MEDECIN)
)
/

/*==============================================================*/
/* Index : SUPERVISION_MEDECIN_FK                               */
/*==============================================================*/
create index SUPERVISION_MEDECIN_FK on MEDECIN (
   ID_ARC ASC
)
/

/*==============================================================*/
/* Index : CENTRE_MEDECIN_FK                                    */
/*==============================================================*/
create index CENTRE_MEDECIN_FK on MEDECIN (
   ID_CENTRE_EC ASC
)
/

/*==============================================================*/
/* Table : PATIENT                                              */
/*==============================================================*/
create table PATIENT (
   ID_PATIENT           NUMBER                not null,
   NUM_ADELI_MEDECIN    NUMBER                not null,
   NOM_PATIENT          VARCHAR2(1024)        not null,
   PRENOM_PATIENT       VARCHAR2(1024)        not null,
   SEXE_PATIENT         VARCHAR2(1)           not null
      constraint CKC_SEXE_PATIENT_PATIENT check (SEXE_PATIENT in ('F','M')),
   DDN_PATIENT          CHAR(10)              not null,
   NUM_SECU_PATIENT     NUMBER                not null,
   MENOPAUSE            NUMBER                not null
      constraint CKC_MENOPAUSE_PATIENT check (MENOPAUSE in (0,1)),
   VACCINATIONGRIPPE    NUMBER                not null
      constraint CKC_VACCINATIONGRIPPE_PATIENT check (VACCINATIONGRIPPE in (0,1)),
   VACCINATIONCOVID     NUMBER                not null
      constraint CKC_VACCINATIONCOVID_PATIENT check (VACCINATIONCOVID in (0,1)),
   HYPERTENSION         NUMBER                not null
      constraint CKC_HYPERTENSION_PATIENT check (HYPERTENSION in (0,1)),
   OBESITE              NUMBER                not null
      constraint CKC_OBESITE_PATIENT check (OBESITE in (0,1)),
   TYPE_GROUPE          VARCHAR2(2)           not null,
   TYPE_SOUS_GROUPE     NUMBER                not null,
   DATE_FIN_INCLUSION   DATE,
   MOTIF_FIN_INCLUSION  CLOB,
   constraint PK_PATIENT primary key (ID_PATIENT)
)
/

/*==============================================================*/
/* Index : SUPERVISION_PATIENT_FK                               */
/*==============================================================*/
create index SUPERVISION_PATIENT_FK on PATIENT (
   NUM_ADELI_MEDECIN ASC
)
/

/*==============================================================*/
/* Table : PATIENTCENTRE                                        */
/*==============================================================*/
create table PATIENTCENTRE (
   ID_CENTRE_EC         NUMBER                not null,
   ID_PATIENT           NUMBER                not null,
   constraint PK_PATIENTCENTRE primary key (ID_CENTRE_EC, ID_PATIENT)
)
/

/*==============================================================*/
/* Index : CENTRE_PATIENT_FK                                    */
/*==============================================================*/
create index CENTRE_PATIENT_FK on PATIENTCENTRE (
   ID_CENTRE_EC ASC
)
/

/*==============================================================*/
/* Index : CENTRE_PATIENT2_FK                                   */
/*==============================================================*/
create index CENTRE_PATIENT2_FK on PATIENTCENTRE (
   ID_PATIENT ASC
)
/

/*==============================================================*/
/* Table : PCR_COVID_ANALYSE                                    */
/*==============================================================*/
create table PCR_COVID_ANALYSE (
   ID_ANALYSE_PCR_COVID NUMBER                not null,
   ID_PATIENT           NUMBER                not null,
   DATE_ANALYSE_PCR_COVID DATE                  not null,
   DATE_PROCHAINE_ANALYSE_PCR_COV DATE,
   RESULTAT_PCR_COVID   VARCHAR2(1024),
   constraint PK_PCR_COVID_ANALYSE primary key (ID_ANALYSE_PCR_COVID)
)
/

/*==============================================================*/
/* Index : ANALYSE_PCR_FK                                       */
/*==============================================================*/
create index ANALYSE_PCR_FK on PCR_COVID_ANALYSE (
   ID_PATIENT ASC
)
/

/*==============================================================*/
/* Table : SANG_ANALYSE                                         */
/*==============================================================*/
create table SANG_ANALYSE (
   ID_ANALYSE_SANG      NUMBER                not null,
   ID_PATIENT           NUMBER                not null,
   DATE_ANALYSE_SANG    DATE                  not null,
   DATE_PROCHAINE_ANALYSE_SANG DATE,
   COMPLEMENTAIRE_SANG  NUMBER                not null
      constraint CKC_COMPLEMENTAIRE_SA_SANG_ANA check (COMPLEMENTAIRE_SANG in (0,1)),
   RESULTAT_CHOLESTEROL NUMBER,
   RESULTAT_GLYCEMIE    NUMBER,
   RESULTAT_PLAQUETTES  NUMBER,
   RESULTAT_4           NUMBER,
   RESULTAT_5           NUMBER,
   RESULTAT_6           NUMBER,
   constraint PK_SANG_ANALYSE primary key (ID_ANALYSE_SANG)
)
/

/*==============================================================*/
/* Index : ANALYSE_EC_FK                                        */
/*==============================================================*/
create index ANALYSE_EC_FK on SANG_ANALYSE (
   ID_PATIENT ASC
)
/

/*==============================================================*/
/* Table : TRACABILITE_MEDECIN_VISITE                           */
/*==============================================================*/
create table TRACABILITE_MEDECIN_VISITE (
   NUM_ADELI_MEDECIN    NUMBER                not null,
   ID_VISITE_QUOTIDIENNE NUMBER                not null,
   constraint PK_TRACABILITE_MEDECIN_VISITE primary key (NUM_ADELI_MEDECIN, ID_VISITE_QUOTIDIENNE)
)
/

/*==============================================================*/
/* Index : TRACABILITE_MEDECIN_VISITE_FK                        */
/*==============================================================*/
create index TRACABILITE_MEDECIN_VISITE_FK on TRACABILITE_MEDECIN_VISITE (
   NUM_ADELI_MEDECIN ASC
)
/

/*==============================================================*/
/* Index : TRACABILITE_MEDECIN_VISITE2_FK                       */
/*==============================================================*/
create index TRACABILITE_MEDECIN_VISITE2_FK on TRACABILITE_MEDECIN_VISITE (
   ID_VISITE_QUOTIDIENNE ASC
)
/

/*==============================================================*/
/* Table : TRAITEMENT_PATHOLOGIE_CARNET_M                       */
/*==============================================================*/
create table TRAITEMENT_PATHOLOGIE_CARNET_M (
   ID_TRAITEMENT_CM     NUMBER                not null,
   ID_CARNET_MEDICAL    NUMBER                not null,
   NOM_MEDICAMENT_CM    VARCHAR2(1024)        not null,
   DATE_DEBUT_TRAITEMENT_CM DATE                  not null,
   DATE_FIN_TRAITEMENT_CM DATE,
   POSOLOGIE_CM         NUMBER                not null,
   constraint PK_TRAITEMENT_PATHOLOGIE_CARNE primary key (ID_TRAITEMENT_CM)
)
/

/*==============================================================*/
/* Index : TRAITER_PATHOLOGIE_FK                                */
/*==============================================================*/
create index TRAITER_PATHOLOGIE_FK on TRAITEMENT_PATHOLOGIE_CARNET_M (
   ID_CARNET_MEDICAL ASC
)
/

/*==============================================================*/
/* Table : VISITE_QUOTIDIENNE                                   */
/*==============================================================*/
create table VISITE_QUOTIDIENNE (
   ID_VISITE_QUOTIDIENNE NUMBER                not null,
   ID_PATIENT           NUMBER                not null,
   DATE_VISITE_QUOTIDIENNE DATE                  not null,
   POIDS                NUMBER,
   PRESSION_ARTERIELLE  NUMBER                not null,
   RYTHME_CARDIAQUE     NUMBER                not null,
   TEMPERATURE          NUMBER,
   COMMENTAIRE          CLOB,
   DEBUT_DE_JOURNEE     NUMBER                not null,
   JOUR_ETUDE           NUMBER                not null,
   constraint PK_VISITE_QUOTIDIENNE primary key (ID_VISITE_QUOTIDIENNE)
)
/

/*==============================================================*/
/* Index : VISITE_PATIENT_FK                                    */
/*==============================================================*/
create index VISITE_PATIENT_FK on VISITE_QUOTIDIENNE (
   ID_PATIENT ASC
)
/

alter table ACTE_MEDICAL_CARNET_MEDICAL
   add constraint FK_ACTE_MED_TRAITER_P_LIGNE_CA foreign key (ID_CARNET_MEDICAL)
      references LIGNE_CARNET_MEDICAL (ID_CARNET_MEDICAL)
/

alter table ADMINISTRATION_LOT
   add constraint FK_ADMINIST_ADMINISTR_VISITE_Q foreign key (ID_VISITE_QUOTIDIENNE)
      references VISITE_QUOTIDIENNE (ID_VISITE_QUOTIDIENNE)
/

alter table ADMINISTRATION_LOT
   add constraint FK_ADMINIST_ADMINISTR_LOTS foreign key (NUMERO_LOT)
      references LOTS (NUMERO_LOT)
/

alter table ARC
   add constraint FK_ARC_ARCCENTRE_CENTRE_E foreign key (ID_CENTRE_EC)
      references CENTRE_EC (ID_CENTRE_EC)
/

alter table AUXILIAIRE
   add constraint FK_AUXILIAI_AUXILIAIR_CENTRE_E foreign key (ID_CENTRE_EC)
      references CENTRE_EC (ID_CENTRE_EC)
/

alter table AUXILIAIRE_VISITE_TRACABILITE
   add constraint FK_AUXILIAI_AUXILIAIR_AUXILIAI foreign key (NUM_ADELI_AUXILIAIRE)
      references AUXILIAIRE (NUM_ADELI_AUXILIAIRE)
/

alter table AUXILIAIRE_VISITE_TRACABILITE
   add constraint FK_AUXILIAI_AUXILIAIR_VISITE_Q foreign key (ID_VISITE_QUOTIDIENNE)
      references VISITE_QUOTIDIENNE (ID_VISITE_QUOTIDIENNE)
/


alter table EEG_ANALYSE
   add constraint FK_EEG_ANAL_ANALYSE_T_PATIENT foreign key (ID_PATIENT)
      references PATIENT (ID_PATIENT)
/

alter table EFFORT_ANALYSE
   add constraint FK_EFFORT_A_ANALYSE_T_PATIENT foreign key (ID_PATIENT)
      references PATIENT (ID_PATIENT)
/

alter table LIGNE_CARNET_MEDICAL
   add constraint FK_LIGNE_CA_SUIVI_PAT_PATIENT foreign key (ID_PATIENT)
      references PATIENT (ID_PATIENT)
/

alter table MEDECIN
   add constraint FK_MEDECIN_MEDECINCE_CENTRE_E foreign key (ID_CENTRE_EC)
      references CENTRE_EC (ID_CENTRE_EC)
/

alter table MEDECIN
   add constraint FK_MEDECIN_SUPERVISI_ARC foreign key (ID_ARC)
      references ARC (ID_ARC)
/

alter table PATIENT
   add constraint FK_PATIENT_SUPERVISI_MEDECIN foreign key (NUM_ADELI_MEDECIN)
      references MEDECIN (NUM_ADELI_MEDECIN)
/

alter table PATIENTCENTRE
   add constraint FK_PATIENTC_PATIENTCE_CENTRE_E foreign key (ID_CENTRE_EC)
      references CENTRE_EC (ID_CENTRE_EC)
/

alter table PATIENTCENTRE
   add constraint FK_PATIENTC_PATIENTCE_PATIENT foreign key (ID_PATIENT)
      references PATIENT (ID_PATIENT)
/

alter table PCR_COVID_ANALYSE
   add constraint FK_PCR_COVI_ANALYSE_P_PATIENT foreign key (ID_PATIENT)
      references PATIENT (ID_PATIENT)
/

alter table SANG_ANALYSE
   add constraint FK_SANG_ANA_ANALYSE_S_PATIENT foreign key (ID_PATIENT)
      references PATIENT (ID_PATIENT)
/

alter table TRACABILITE_MEDECIN_VISITE
   add constraint FK_TRACABIL_TRACABILI_MEDECIN foreign key (NUM_ADELI_MEDECIN)
      references MEDECIN (NUM_ADELI_MEDECIN)
/

alter table TRACABILITE_MEDECIN_VISITE
   add constraint FK_TRACABIL_TRACABILI_VISITE_Q foreign key (ID_VISITE_QUOTIDIENNE)
      references VISITE_QUOTIDIENNE (ID_VISITE_QUOTIDIENNE)
/

alter table TRAITEMENT_PATHOLOGIE_CARNET_M
   add constraint FK_TRAITEME_MEDICAMEN_LIGNE_CA foreign key (ID_CARNET_MEDICAL)
      references LIGNE_CARNET_MEDICAL (ID_CARNET_MEDICAL)
/

alter table VISITE_QUOTIDIENNE
   add constraint FK_VISITE_Q_VISITE_PA_PATIENT foreign key (ID_PATIENT)
      references PATIENT (ID_PATIENT)
/


create or replace trigger COMPOUNDDELETETRIGGER_ACTE_MED
for delete on ACTE_MEDICAL_CARNET_MEDICAL compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDINSERTTRIGGER_ACTE_MED
for insert on ACTE_MEDICAL_CARNET_MEDICAL compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDUPDATETRIGGER_ACTE_MED
for update on ACTE_MEDICAL_CARNET_MEDICAL compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create trigger TIB_ACTE_MEDICAL_CARNET_MEDICA before insert
on ACTE_MEDICAL_CARNET_MEDICAL for each row
declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;

begin
    --  La colonne "ID_ACTE_MEDICAL" utilise la séquence AI_ACTE_MEDICAL
    select AI_ACTE_MEDICAL.NEXTVAL INTO :new.ID_ACTE_MEDICAL from dual;

--  Traitement d'erreurs
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/


create or replace trigger COMPOUNDDELETETRIGGER_ARC
for delete on ARC compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDINSERTTRIGGER_ARC
for insert on ARC compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDUPDATETRIGGER_ARC
for update on ARC compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create trigger TIB_ARC before insert
on ARC for each row
declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;

begin
    --  La colonne "ID_ARC" utilise la séquence AI_ARC
    select AI_ARC.NEXTVAL INTO :new.ID_ARC from dual;

--  Traitement d'erreurs
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/


create or replace trigger COMPOUNDDELETETRIGGER_CENTRE_E
for delete on CENTRE_EC compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDINSERTTRIGGER_CENTRE_E
for insert on CENTRE_EC compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDUPDATETRIGGER_CENTRE_E
for update on CENTRE_EC compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create trigger TIB_CENTRE_EC before insert
on CENTRE_EC for each row
declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;

begin
    --  La colonne "ID_CENTRE_EC" utilise la séquence AI_CENTRE_EC
    select AI_CENTRE_EC.NEXTVAL INTO :new.ID_CENTRE_EC from dual;

--  Traitement d'erreurs
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/


create or replace trigger COMPOUNDDELETETRIGGER_EFFORT_A
for delete on EFFORT_ANALYSE compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDINSERTTRIGGER_EFFORT_A
for insert on EFFORT_ANALYSE compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDUPDATETRIGGER_EFFORT_A
for update on EFFORT_ANALYSE compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create trigger TIB_EFFORT_ANALYSE before insert
on EFFORT_ANALYSE for each row
declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;

begin
    --  La colonne "ID_ANALYSE_EFFORT" utilise la séquence AI_ANALYSE_EFFORT
    select AI_ANALYSE_EFFORT.NEXTVAL INTO :new.ID_ANALYSE_EFFORT from dual;

--  Traitement d'erreurs
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/


create or replace trigger COMPOUNDDELETETRIGGER_LIGNE_CA
for delete on LIGNE_CARNET_MEDICAL compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDINSERTTRIGGER_LIGNE_CA
for insert on LIGNE_CARNET_MEDICAL compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDUPDATETRIGGER_LIGNE_CA
for update on LIGNE_CARNET_MEDICAL compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create trigger TIB_LIGNE_CARNET_MEDICAL before insert
on LIGNE_CARNET_MEDICAL for each row
declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;

begin
    --  La colonne "ID_CARNET_MEDICAL" utilise la séquence AI_ID_CARNET_MEDICAL
    select AI_ID_CARNET_MEDICAL.NEXTVAL INTO :new.ID_CARNET_MEDICAL from dual;

--  Traitement d'erreurs
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/


create or replace trigger COMPOUNDDELETETRIGGER_MEDECIN
for delete on MEDECIN compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDINSERTTRIGGER_MEDECIN
for insert on MEDECIN compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDUPDATETRIGGER_MEDECIN
for update on MEDECIN compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDDELETETRIGGER_PATIENT
for delete on PATIENT compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDINSERTTRIGGER_PATIENT
for insert on PATIENT compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDUPDATETRIGGER_PATIENT
for update on PATIENT compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create trigger TIB_PATIENT before insert
on PATIENT for each row
declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;

begin
    --  La colonne "ID_PATIENT" utilise la séquence AI_PATIENT
    select AI_PATIENT.NEXTVAL INTO :new.ID_PATIENT from dual;

--  Traitement d'erreurs
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/


create or replace trigger COMPOUNDDELETETRIGGER_PCR_COVI
for delete on PCR_COVID_ANALYSE compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDINSERTTRIGGER_PCR_COVI
for insert on PCR_COVID_ANALYSE compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDUPDATETRIGGER_PCR_COVI
for update on PCR_COVID_ANALYSE compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create trigger TIB_PCR_COVID_ANALYSE before insert
on PCR_COVID_ANALYSE for each row
declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;

begin
    --  La colonne "ID_ANALYSE_PCR_COVID" utilise la séquence AI_ANALYSE_PCR_COVID
    select AI_ANALYSE_PCR_COVID.NEXTVAL INTO :new.ID_ANALYSE_PCR_COVID from dual;

--  Traitement d'erreurs
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/


create or replace trigger COMPOUNDDELETETRIGGER_SANG_ANA
for delete on SANG_ANALYSE compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDINSERTTRIGGER_SANG_ANA
for insert on SANG_ANALYSE compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDUPDATETRIGGER_SANG_ANA
for update on SANG_ANALYSE compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create trigger TIB_SANG_ANALYSE before insert
on SANG_ANALYSE for each row
declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;

begin
    --  La colonne "ID_ANALYSE_SANG" utilise la séquence AI_ANALYSE_SANG
    select AI_ANALYSE_SANG.NEXTVAL INTO :new.ID_ANALYSE_SANG from dual;

--  Traitement d'erreurs
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/


create or replace trigger COMPOUNDDELETETRIGGER_TRAITEME
for delete on TRAITEMENT_PATHOLOGIE_CARNET_M compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDINSERTTRIGGER_TRAITEME
for insert on TRAITEMENT_PATHOLOGIE_CARNET_M compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDUPDATETRIGGER_TRAITEME
for update on TRAITEMENT_PATHOLOGIE_CARNET_M compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create trigger TIB_TRAITEMENT_PATHOLOGIE_CARN before insert
on TRAITEMENT_PATHOLOGIE_CARNET_M for each row
declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;

begin
    --  La colonne "ID_TRAITEMENT_CM" utilise la séquence AI_ID_TRAITEMENT
    select AI_ID_TRAITEMENT.NEXTVAL INTO :new.ID_TRAITEMENT_CM from dual;

--  Traitement d'erreurs
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/


create or replace trigger COMPOUNDDELETETRIGGER_VISITE_Q
for delete on VISITE_QUOTIDIENNE compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDINSERTTRIGGER_VISITE_Q
for insert on VISITE_QUOTIDIENNE compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create or replace trigger COMPOUNDUPDATETRIGGER_VISITE_Q
for update on VISITE_QUOTIDIENNE compound trigger
// Déclaration
// Corps
  before statement is
  begin
     NULL;
  end before statement;

  before each row is
  begin
     NULL;
  end before each row;

  after each row is
  begin
     NULL;
  end after each row;

  after statement is
  begin
     NULL;
  end after statement;

END
/


create trigger TIB_VISITE_QUOTIDIENNE before insert
on VISITE_QUOTIDIENNE for each row
declare
    integrity_error  exception;
    errno            integer;
    errmsg           char(200);
    dummy            integer;
    found            boolean;

begin
    --  La colonne "ID_VISITE_QUOTIDIENNE" utilise la séquence AI_VISITE_QUOTIDIENNE
    select AI_VISITE_QUOTIDIENNE.NEXTVAL INTO :new.ID_VISITE_QUOTIDIENNE from dual;

--  Traitement d'erreurs
exception
    when integrity_error then
       raise_application_error(errno, errmsg);
end;
/




