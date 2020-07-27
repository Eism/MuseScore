//=============================================================================
//  MuseScore
//  Music Composition & Notation
//
//  Copyright (C) 2020 MuseScore BVBA and others
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//=============================================================================
#include "userscoresmodule.h"

#include <QQmlEngine>

#include "modularity/ioc.h"
#include "view/recentscoresmodel.h"
#include "view/newscoremodel.h"
#include "view/scorethumbnail.h"
#include "internal/openscorecontroller.h"
#include "internal/userscoresconfiguration.h"

using namespace mu::userscores;

static OpenScoreController* m_openController = new OpenScoreController();
static UserScoresConfiguration* m_userScoresConfiguration = new UserScoresConfiguration();

static void userscores_init_qrc()
{
    Q_INIT_RESOURCE(userscores);
}

std::string UserScoresModule::moduleName() const
{
    return "userscores";
}

void UserScoresModule::registerExports()
{
    framework::ioc()->registerExport<IOpenScoreController>(moduleName(), m_openController);
    framework::ioc()->registerExport<IUserScoresConfiguration>(moduleName(), m_userScoresConfiguration);
}

void UserScoresModule::registerResources()
{
    userscores_init_qrc();
}

void UserScoresModule::registerUiTypes()
{
    qmlRegisterType<RecentScoresModel>("MuseScore.UserScores", 1, 0, "RecentScoresModel");
    qmlRegisterType<NewScoreModel>("MuseScore.UserScores", 1, 0, "NewScoreModel");
    qmlRegisterType<ScoreThumbnail>("MuseScore.UserScores", 1, 0, "ScoreThumbnail");
}

void UserScoresModule::onInit()
{
    m_userScoresConfiguration->init();
    m_openController->init();
}
