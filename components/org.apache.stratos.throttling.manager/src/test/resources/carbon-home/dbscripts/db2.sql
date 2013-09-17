/*
* Licensed to the Apache Software Foundation (ASF) under one
* or more contributor license agreements. See the NOTICE file
* distributed with this work for additional information
* regarding copyright ownership. The ASF licenses this file
* to you under the Apache License, Version 2.0 (the
* "License"); you may not use this file except in compliance
* with the License. You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an
* "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
* KIND, either express or implied. See the License for the
* specific language governing permissions and limitations
* under the License.
*/ 

CREATE TABLE REG_CLUSTER_LOCK (
             REG_LOCK_NAME VARCHAR (20) NOT NULL,
             REG_LOCK_STATUS VARCHAR (20),
             REG_LOCKED_TIME TIMESTAMP,
             REG_TENANT_ID INTEGER DEFAULT 0,
             PRIMARY KEY (REG_LOCK_NAME)
);

CREATE TABLE REG_LOG (
             REG_LOG_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) ,
             REG_PATH VARCHAR (2000),
             REG_USER_ID VARCHAR (31) NOT NULL,
             REG_LOGGED_TIME TIMESTAMP NOT NULL,
             REG_ACTION INTEGER NOT NULL,
             REG_ACTION_DATA VARCHAR (500),
             REG_TENANT_ID INTEGER DEFAULT 0,
             PRIMARY KEY (REG_LOG_ID)
);

CREATE TABLE REG_PATH(
             REG_PATH_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
             REG_PATH_VALUE VARCHAR(2000) NOT NULL,
             REG_PATH_PARENT_ID INTEGER,
             REG_TENANT_ID INTEGER DEFAULT 0,
             CONSTRAINT PK_REG_PATH PRIMARY KEY(REG_PATH_ID)
);
-- This index cannot be created due to large length of REG_PATH_VALUE column - sumedha
--CREATE UNIQUE INDEX REG_PATH_IND_BY_PATH_PATH_VALUE ON REG_PATH(REG_PATH_VALUE);

CREATE TABLE REG_CONTENT (
             REG_CONTENT_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
             REG_CONTENT_DATA BLOB(2G),
             REG_TENANT_ID INTEGER DEFAULT 0,
             CONSTRAINT PK_REG_CONTENT PRIMARY KEY(REG_CONTENT_ID)
);

CREATE TABLE REG_CONTENT_HISTORY (
             REG_CONTENT_ID INTEGER NOT NULL,
             REG_CONTENT_DATA BLOB(2G),
             REG_DELETED   SMALLINT,
             REG_TENANT_ID INTEGER DEFAULT 0,
             CONSTRAINT PK_REG_CONTENT_HISTORY PRIMARY KEY(REG_CONTENT_ID)
);

CREATE TABLE REG_RESOURCE (
            REG_PATH_ID         INTEGER NOT NULL,
            REG_NAME            VARCHAR(256),
            REG_VERSION         INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
            REG_MEDIA_TYPE      VARCHAR(500),
            REG_CREATOR         VARCHAR(31) NOT NULL,
            REG_CREATED_TIME    TIMESTAMP NOT NULL,
            REG_LAST_UPDATOR    VARCHAR(31),
            REG_LAST_UPDATED_TIME    TIMESTAMP NOT NULL,
            REG_DESCRIPTION     VARCHAR(1000),
            REG_CONTENT_ID      INTEGER,
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_RESOURCE PRIMARY KEY(REG_VERSION)
            /**CONSTRAINT PK_REG_RESOURCE PRIMARY KEY(PATH_ID,NAME,VERSION)*/
);

ALTER TABLE REG_RESOURCE ADD CONSTRAINT REG_RESOURCE_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID) REFERENCES REG_PATH (REG_PATH_ID);
ALTER TABLE REG_RESOURCE ADD CONSTRAINT REG_RESOURCE_FK_BY_CONTENT_ID FOREIGN KEY (REG_CONTENT_ID) REFERENCES REG_CONTENT (REG_CONTENT_ID);
CREATE UNIQUE INDEX REG_RESOURCE_IND_BY_NAME ON REG_RESOURCE(REG_NAME);
CREATE UNIQUE INDEX REG_RESOURCE_IND_BY_PATH_ID_NAME ON REG_RESOURCE(REG_PATH_ID, REG_NAME);

CREATE TABLE REG_RESOURCE_HISTORY (
            REG_PATH_ID         INTEGER NOT NULL,
            REG_NAME            VARCHAR(256),
            REG_VERSION         INTEGER NOT NULL,
            REG_MEDIA_TYPE      VARCHAR(500),
            REG_CREATOR         VARCHAR(31) NOT NULL,
            REG_CREATED_TIME    TIMESTAMP NOT NULL,
            REG_LAST_UPDATOR    VARCHAR(31),
            REG_LAST_UPDATED_TIME    TIMESTAMP NOT NULL,
            REG_DESCRIPTION     VARCHAR(1000),
            REG_CONTENT_ID      INTEGER,
            REG_DELETED         SMALLINT,
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_RESOURCE_HISTORY PRIMARY KEY(REG_VERSION)
);

ALTER TABLE REG_RESOURCE_HISTORY ADD CONSTRAINT REG_RESOURCE_HIST_FK_BY_PATHID FOREIGN KEY (REG_PATH_ID) REFERENCES REG_PATH (REG_PATH_ID);
ALTER TABLE REG_RESOURCE_HISTORY ADD CONSTRAINT REG_RESOURCE_HIST_FK_BY_CONTENT_ID FOREIGN KEY (REG_CONTENT_ID) REFERENCES REG_CONTENT_HISTORY (REG_CONTENT_ID);
CREATE UNIQUE INDEX REG_RESOURCE_HISTORY_IND_BY_NAME ON REG_RESOURCE_HISTORY(REG_NAME);
CREATE UNIQUE INDEX REG_RESOURCE_HISTORY_IND_BY_PATH_ID_NAME ON REG_RESOURCE(REG_PATH_ID, REG_NAME);

CREATE TABLE REG_COMMENT (
            REG_ID        INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
            REG_COMMENT_TEXT      VARCHAR(500) NOT NULL,
            REG_USER_ID           VARCHAR(31) NOT NULL,
            REG_COMMENTED_TIME    TIMESTAMP NOT NULL,
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_COMMENT PRIMARY KEY(REG_ID)
);

CREATE TABLE REG_RESOURCE_COMMENT (
            REG_COMMENT_ID          INTEGER NOT NULL,
            REG_VERSION             INTEGER NOT NULL,
            REG_PATH_ID             INTEGER,
            REG_RESOURCE_NAME       VARCHAR(256),
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_RESOURCE_COMMENT PRIMARY KEY(REG_VERSION, REG_COMMENT_ID)
);

ALTER TABLE REG_RESOURCE_COMMENT ADD CONSTRAINT REG_RESOURCE_COMMENT_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID) REFERENCES REG_PATH (REG_PATH_ID);
ALTER TABLE REG_RESOURCE_COMMENT ADD CONSTRAINT REG_RESOURCE_COMMENT_FK_BY_COMMENT_ID FOREIGN KEY (REG_COMMENT_ID) REFERENCES REG_COMMENT (REG_ID);
CREATE UNIQUE INDEX REG_RESOURCE_COMMENT_IND_BY_PATH_ID_AND_RESOURCE_NAME  ON REG_RESOURCE_COMMENT(REG_PATH_ID, REG_RESOURCE_NAME);
CREATE UNIQUE INDEX REG_RESOURCE_COMMENT_IND_BY_VERSION  ON REG_RESOURCE_COMMENT(REG_VERSION);

CREATE TABLE REG_RATING (
            REG_ID     INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
            REG_RATING        INTEGER NOT NULL,
            REG_USER_ID       VARCHAR(31) NOT NULL,
            REG_RATED_TIME    TIMESTAMP NOT NULL,
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_RATING PRIMARY KEY(REG_ID)
);

CREATE TABLE REG_RESOURCE_RATING (
            REG_RATING_ID           INTEGER NOT NULL,
            REG_VERSION             INTEGER NOT NULL,
            REG_PATH_ID             INTEGER,
            REG_RESOURCE_NAME       VARCHAR(256),
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_RESOURCE_RATING PRIMARY KEY(REG_VERSION, REG_RATING_ID)
);

ALTER TABLE REG_RESOURCE_RATING ADD CONSTRAINT REG_RESOURCE_RATING_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID) REFERENCES REG_PATH (REG_PATH_ID);
ALTER TABLE REG_RESOURCE_RATING ADD CONSTRAINT REG_RESOURCE_RATING_FK_BY_RATING_ID FOREIGN KEY (REG_RATING_ID) REFERENCES REG_RATING (REG_ID);
CREATE UNIQUE INDEX REG_RESOURCE_RATING_IND_BY_PATH_ID_AND_RESOURCE_NAME  ON REG_RESOURCE_RATING(REG_PATH_ID, REG_RESOURCE_NAME);
CREATE UNIQUE INDEX REG_RESOURCE_RATING_IND_BY_VERSION  ON REG_RESOURCE_RATING(REG_VERSION);


CREATE TABLE REG_TAG (
            REG_ID         INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
            REG_TAG_NAME       VARCHAR(500) NOT NULL,
            REG_USER_ID        VARCHAR(31) NOT NULL,
            REG_TAGGED_TIME    TIMESTAMP NOT NULL,
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_TAG PRIMARY KEY(REG_ID)
);

CREATE TABLE REG_RESOURCE_TAG (
            REG_TAG_ID              INTEGER NOT NULL,
            REG_VERSION             INTEGER NOT NULL,
            REG_PATH_ID             INTEGER,
            REG_RESOURCE_NAME       VARCHAR(256),
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_RESOURCE_TAG PRIMARY KEY(REG_VERSION, REG_TAG_ID)
);

ALTER TABLE REG_RESOURCE_TAG ADD CONSTRAINT REG_RESOURCE_TAG_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID) REFERENCES REG_PATH (REG_PATH_ID);
ALTER TABLE REG_RESOURCE_TAG ADD CONSTRAINT REG_RESOURCE_TAG_FK_BY_TAG_ID FOREIGN KEY (REG_TAG_ID) REFERENCES REG_TAG (REG_ID);
CREATE UNIQUE INDEX REG_RESOURCE_TAG_IND_BY_PATH_ID_AND_RESOURCE_NAME  ON REG_RESOURCE_TAG(REG_PATH_ID, REG_RESOURCE_NAME);
CREATE UNIQUE INDEX REG_RESOURCE_TAG_IND_BY_VERSION  ON REG_RESOURCE_TAG(REG_VERSION);

CREATE TABLE REG_PROPERTY (
            REG_ID         INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
            REG_NAME       VARCHAR(100) NOT NULL,
            REG_VALUE        VARCHAR(1000),
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_PROPERTY PRIMARY KEY(REG_ID)
);

CREATE TABLE REG_RESOURCE_PROPERTY (
            REG_PROPERTY_ID         INTEGER NOT NULL,
            REG_VERSION             INTEGER NOT NULL,
            REG_PATH_ID             INTEGER,
            REG_RESOURCE_NAME       VARCHAR(256),
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_RESOURCE_PROPERTY PRIMARY KEY(REG_VERSION, REG_PROPERTY_ID)
);

ALTER TABLE REG_RESOURCE_PROPERTY ADD CONSTRAINT REG_RESOURCE_PROPERTY_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID) REFERENCES REG_PATH (REG_PATH_ID);
ALTER TABLE REG_RESOURCE_PROPERTY ADD CONSTRAINT REG_RESOURCE_PROPERTY_FK_BY_TAG_ID FOREIGN KEY (REG_PROPERTY_ID) REFERENCES REG_PROPERTY (REG_ID);
CREATE UNIQUE INDEX REG_RESOURCE_PROPERTY_IND_BY_PATH_ID_AND_RESOURCE_NAME  ON REG_RESOURCE_PROPERTY(REG_PATH_ID, REG_RESOURCE_NAME);
CREATE UNIQUE INDEX REG_RESOURCE_PROPERTY_IND_BY_VERSION  ON REG_RESOURCE_PROPERTY(REG_VERSION);

-- CREATE TABLE REG_ASSOCIATIONS (
-- SRC_PATH_ID     INTEGER,
-- SRC_RESOURCE_NAME    VARCHAR(256),
-- SRC_VERSION     INTEGER,
-- TGT_PATH_ID     INTEGER,
-- TGT_RESOURCE_NAME    VARCHAR(256),
-- TGT_VERSION     INTEGER
-- );
-- 
-- ALTER TABLE REG_ASSOCIATIONS ADD CONSTRAINT REG_ASSOCIATIONS_FK_BY_SRC_PATH_ID FOREIGN KEY (SRC_PATH_ID) REFERENCES REG_PATH (PATH_ID);
-- ALTER TABLE REG_ASSOCIATIONS ADD CONSTRAINT REG_ASSOCIATIONS_FK_BY_TGT_PATH_ID FOREIGN KEY (TGT_PATH_ID) REFERENCES REG_PATH (PATH_ID);
-- CREATE UNIQUE INDEX REG_ASSOCIATIONS_IND_BY_SRC_VERSION ON REG_ASSOCIATIONS(SRC_VERSION);
-- CREATE UNIQUE INDEX REG_ASSOCIATIONS_IND_BY_TGT_VERSION ON REG_ASSOCIATIONS(TGT_VERSION);
-- CREATE UNIQUE INDEX REG_ASSOCIATIONS_IND_BY_SRC_RESOURCE_NAME ON REG_ASSOCIATIONS(SRC_RESOURCE_NAME);
-- CREATE UNIQUE INDEX REG_ASSOCIATIONS_IND_BY_TGT_RESOURCE_NAME ON REG_ASSOCIATIONS(TGT_RESOURCE_NAME);



--had to reduce REG_SOURCEPATH from 2000 to 1700, REG_TARGETPATH from 2000 to 1700 and REG_ASSOCIATION_TYPE from 2000 to 500
CREATE TABLE REG_ASSOCIATION (
            REG_ASSOCIATION_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
            REG_SOURCEPATH VARCHAR(1700) NOT NULL,
            REG_TARGETPATH VARCHAR(1700) NOT NULL,
            REG_ASSOCIATION_TYPE VARCHAR(500) NOT NULL,
            REG_TENANT_ID INTEGER DEFAULT 0,
            PRIMARY KEY (REG_ASSOCIATION_ID)
);

CREATE TABLE REG_SNAPSHOT (
            REG_SNAPSHOT_ID     INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
            REG_PATH_ID            INTEGER NOT NULL,
            REG_RESOURCE_NAME      VARCHAR(255),
            REG_RESOURCE_VIDS     BLOB(2G) NOT NULL,
            REG_TENANT_ID INTEGER DEFAULT 0,
            CONSTRAINT PK_REG_SNAPSHOT PRIMARY KEY(REG_SNAPSHOT_ID)
);

CREATE UNIQUE INDEX REG_SNAPSHOT_IND_BY_PATH_ID_AND_RESOURCE_NAME ON REG_SNAPSHOT(REG_PATH_ID, REG_RESOURCE_NAME);

ALTER TABLE REG_SNAPSHOT ADD CONSTRAINT REG_SNAPSHOT_FK_BY_PATH_ID FOREIGN KEY (REG_PATH_ID) REFERENCES REG_PATH (REG_PATH_ID);


-- ################################
-- USER MANAGER TABLES
-- ################################

CREATE TABLE UM_USER ( 
             UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
             UM_USER_NAME VARCHAR(255) NOT NULL, 
             UM_USER_PASSWORD VARCHAR(255) NOT NULL,
             UM_SALT_VALUE VARCHAR(31),
             UM_REQUIRE_CHANGE BOOLEAN DEFAULT FALSE,
             UM_CHANGED_TIME TIMESTAMP NOT NULL,
             UM_TENANT_ID INTEGER DEFAULT 0, 
             PRIMARY KEY (UM_ID), 
             UNIQUE(UM_USER_NAME) 
); 

CREATE TABLE UM_ROLE ( 
             UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
             UM_ROLE_NAME VARCHAR(255) NOT NULL,
             UM_TENANT_ID INTEGER DEFAULT 0,  
             PRIMARY KEY (UM_ID), 
             UNIQUE(UM_ROLE_NAME) 
); 

CREATE TABLE UM_ROLE_ATTRIBUTE ( 
             UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
             UM_ATTR_NAME VARCHAR(255) NOT NULL, 
             UM_ATTR_VALUE VARCHAR(255), 
             UM_ROLE_ID INTEGER,
             UM_TENANT_ID INTEGER DEFAULT 0,  
             FOREIGN KEY (UM_ROLE_ID) REFERENCES UM_ROLE(UM_ID), 
             PRIMARY KEY (UM_ID) 
); 

CREATE TABLE UM_PERMISSION ( 
             UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
             UM_RESOURCE_ID VARCHAR(255) NOT NULL, 
             UM_ACTION VARCHAR(255) NOT NULL, 
             UM_TENANT_ID INTEGER DEFAULT 0, 
             PRIMARY KEY (UM_ID) 
); 

CREATE UNIQUE INDEX INDEX_UM_PERMISSION_UM_RESOURCE_ID_UM_ACTION 
                    ON UM_PERMISSION (UM_RESOURCE_ID, UM_ACTION); 

CREATE TABLE UM_ROLE_PERMISSION ( 
             UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
             UM_PERMISSION_ID INTEGER NOT NULL, 
             UM_ROLE_ID INTEGER NOT NULL, 
             UM_IS_ALLOWED SMALLINT NOT NULL, 
             UM_TENANT_ID INTEGER DEFAULT 0, 
             FOREIGN KEY (UM_PERMISSION_ID) REFERENCES UM_PERMISSION(UM_ID) ON DELETE CASCADE, 
             FOREIGN KEY (UM_ROLE_ID) REFERENCES UM_ROLE(UM_ID), 
             PRIMARY KEY (UM_ID) 
); 
-- REMOVED UNIQUE (UM_PERMISSION_ID, UM_ROLE_ID) 
 

CREATE TABLE UM_USER_PERMISSION ( 
             UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
             UM_PERMISSION_ID INTEGER NOT NULL, 
             UM_USER_ID INTEGER NOT NULL, 
             UM_IS_ALLOWED SMALLINT NOT NULL,             
             UM_TENANT_ID INTEGER DEFAULT 0, 
             FOREIGN KEY (UM_PERMISSION_ID) REFERENCES UM_PERMISSION(UM_ID) ON DELETE CASCADE , 
             FOREIGN KEY (UM_USER_ID) REFERENCES UM_USER(UM_ID), 
             PRIMARY KEY (UM_ID) 
); 
-- REMOVED UNIQUE (UM_PERMISSION_ID, UM_USER_ID) 

CREATE TABLE UM_USER_ROLE ( 
             UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
             UM_ROLE_ID INTEGER NOT NULL, 
             UM_USER_ID INTEGER NOT NULL,
             UM_TENANT_ID INTEGER DEFAULT 0,  
             UNIQUE (UM_USER_ID, UM_ROLE_ID), 
             FOREIGN KEY (UM_ROLE_ID) REFERENCES UM_ROLE(UM_ID), 
             FOREIGN KEY (UM_USER_ID) REFERENCES UM_USER(UM_ID), 
             PRIMARY KEY (UM_ID) 
); 


CREATE TABLE UM_USER_DATA ( 
       UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
       UM_USER_ID INTEGER NOT NULL, 
       UM_EMAIL VARCHAR(255), 
       UM_FIRST_NAME VARCHAR(150), 
       UM_LAST_NAME VARCHAR(150), 
       UM_BIRTH_DATE VARCHAR(100), 
       UM_FULL_NAME VARCHAR(255), 
       UM_NAME_PREFIX VARCHAR(30), 
       UM_GENDER VARCHAR(10), 
       UM_TIME_ZONE VARCHAR(100), 
       UM_COMPANY_NAME VARCHAR(255), 
       UM_JOB_TITLE VARCHAR(150), 
       UM_PRIMARY_PHONE VARCHAR(100), 
       UM_HOME_PHONE VARCHAR(100), 
       UM_WORK_PHONE VARCHAR(100), 
       UM_MOBILE_PHONE VARCHAR(100), 
       UM_STREET_ADDRESS VARCHAR(255), 
       UM_CITY VARCHAR(100), 
       UM_STATE VARCHAR(100), 
       UM_COUNTRY VARCHAR(50), 
       UM_POSTAL_CODE VARCHAR(50), 
       UM_WEB_PAGE VARCHAR(255), 
       UM_LANGUAGE VARCHAR(255), 
       UM_BLOG VARCHAR(255), 
       UM_PROFILE_ID VARCHAR(50),
       UM_TENANT_ID INTEGER DEFAULT 0,  
       FOREIGN KEY (UM_USER_ID) REFERENCES UM_USER(UM_ID), 
       PRIMARY KEY (UM_ID) 
); 


CREATE TABLE UM_BIN_DATA ( 
            UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
            UM_USER_ID INTEGER NOT NULL, 
            UM_CONTENT_NAME VARCHAR(255) NOT NULL, 
            UM_CONTENT BLOB NOT NULL, 
            UM_PROFILE_ID VARCHAR(255) NOT NULL, 
            UM_TENANT_ID INTEGER DEFAULT 0, 
            FOREIGN KEY (UM_USER_ID) REFERENCES UM_USER(UM_ID), 
            PRIMARY KEY (UM_ID) 
); 


CREATE TABLE UM_USER_ATTRIBUTE ( 
            UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
            UM_ATTR_NAME VARCHAR(255) NOT NULL, 
            UM_ATTR_VALUE VARCHAR(1024), 
            UM_PROFILE_ID VARCHAR(255), 
            UM_USER_ID INTEGER, 
            UM_TENANT_ID INTEGER DEFAULT 0, 
            FOREIGN KEY (UM_USER_ID) REFERENCES UM_USER(UM_ID), 
            PRIMARY KEY (UM_ID) 
); 



CREATE TABLE UM_DIALECT( 
            UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
            UM_DIALECT_URI VARCHAR(255) NOT NULL, 
            UM_REALM VARCHAR(63) NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0, 
            UNIQUE(UM_DIALECT_URI, UM_REALM), 
            PRIMARY KEY (UM_ID) 
); 

CREATE TABLE UM_CLAIM( 
            UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
            UM_DIALECT_ID INTEGER NOT NULL, 
            UM_CLAIM_URI VARCHAR(255) NOT NULL, 
            UM_DISPLAY_TAG VARCHAR(255), 
            UM_DESCRIPTION VARCHAR(255), 
            UM_MAPPED_ATTRIBUTE VARCHAR(255), 
            UM_REG_EX VARCHAR(255), 
            UM_SUPPORTED SMALLINT, 
            UM_REQUIRED SMALLINT, 
            UM_DISPLAY_ORDER INTEGER,
            UM_TENANT_ID INTEGER DEFAULT 0, 
            UNIQUE(UM_DIALECT_ID, UM_CLAIM_URI), 
            FOREIGN KEY(UM_DIALECT_ID) REFERENCES UM_DIALECT(UM_ID), 
            PRIMARY KEY (UM_ID) 
); 

CREATE TABLE UM_PROFILE_CONFIG( 
            UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
            UM_DIALECT_ID INTEGER NOT NULL, 
            UM_PROFILE_NAME VARCHAR(255), 
            UM_TENANT_ID INTEGER DEFAULT 0, 
            FOREIGN KEY(UM_DIALECT_ID) REFERENCES UM_DIALECT(UM_ID), 
            PRIMARY KEY (UM_ID) 
); 
    
CREATE TABLE UM_CLAIM_BEHAVIOR( 
            UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
            UM_PROFILE_ID INTEGER, 
            UM_CLAIM_ID INTEGER, 
            UM_BEHAVIOUR SMALLINT, 
            UM_TENANT_ID INTEGER DEFAULT 0, 
            FOREIGN KEY(UM_PROFILE_ID) REFERENCES UM_PROFILE_CONFIG(UM_ID), 
            FOREIGN KEY(UM_CLAIM_ID) REFERENCES UM_CLAIM(UM_ID), 
            PRIMARY KEY (UM_ID) 
); 

CREATE TABLE HYBRID_ROLE ( 
             UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
             UM_ROLE_ID VARCHAR(255) NOT NULL, 
             UM_TENANT_ID INTEGER DEFAULT 0, 
             PRIMARY KEY (UM_ID), 
             UNIQUE(UM_ROLE_ID) 
); 

CREATE TABLE HYBRID_USER_ROLE ( 
             UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
             UM_USER_ID VARCHAR(255), 
             UM_ROLE_ID VARCHAR(255) NOT NULL,
             UM_TENANT_ID INTEGER DEFAULT 0,  
             PRIMARY KEY (UM_ID) 
); 

CREATE TABLE HYBRID_PERMISSION ( 
             UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
             UM_RESOURCE_ID VARCHAR(255), 
             UM_ACTION VARCHAR(255) NOT NULL, 
             UM_TENANT_ID INTEGER DEFAULT 0, 
             PRIMARY KEY (UM_ID) 
); 

CREATE TABLE HYBRID_ROLE_PERMISSION ( 
             UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
             UM_PERMISSION_ID INTEGER NOT NULL, 
             UM_ROLE_ID VARCHAR(255) NOT NULL, 
             UM_IS_ALLOWED SMALLINT NOT NULL, 
             UM_TENANT_ID INTEGER DEFAULT 0, 
             UNIQUE (UM_PERMISSION_ID, UM_ROLE_ID), 
             FOREIGN KEY (UM_PERMISSION_ID) REFERENCES HYBRID_PERMISSION(UM_ID), 
             PRIMARY KEY (UM_ID) 
); 

CREATE TABLE HYBRID_USER_PERMISSION ( 
             UM_ID INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), 
             UM_PERMISSION_ID INTEGER NOT NULL, 
             UM_USER_ID VARCHAR(255) NOT NULL, 
             UM_IS_ALLOWED SMALLINT NOT NULL, 
             UM_TENANT_ID INTEGER DEFAULT 0, 
             UNIQUE (UM_PERMISSION_ID, UM_USER_ID), 
             FOREIGN KEY (UM_PERMISSION_ID) REFERENCES HYBRID_PERMISSION(UM_ID), 
             PRIMARY KEY (UM_ID) 
);
