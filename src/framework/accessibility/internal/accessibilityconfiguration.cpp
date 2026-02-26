/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore
 * Music Composition & Notation
 *
 * Copyright (C) 2021 MuseScore Limited and others
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
#include "accessibilityconfiguration.h"

#include <QAccessible>

#include "log.h"

using namespace muse::accessibility;

class AccessibilityActivationObserver : public QAccessible::ActivationObserver
{
public:
    AccessibilityActivationObserver()
    {
        m_isAccessibilityActive = QAccessible::isActive();
        LOGD() << "AccessibilityActivationObserver created, isAccessibilityActive=" << m_isAccessibilityActive;
    }

    bool isAccessibilityActive() const
    {
        return m_isAccessibilityActive;
    }

    void accessibilityActiveChanged(bool active) override
    {
        LOGD() << "accessibilityActiveChanged: " << m_isAccessibilityActive << " -> " << active;
        m_isAccessibilityActive = active;
    }

private:
    bool m_isAccessibilityActive = false;
};

AccessibilityActivationObserver* s_accessibilityActivationObserver = nullptr;

AccessibilityConfiguration::~AccessibilityConfiguration()
{
    LOGD() << "destructor, m_inited=" << m_inited;
    QAccessible::installActivationObserver(nullptr);
    delete s_accessibilityActivationObserver;
    s_accessibilityActivationObserver = nullptr;
}

void AccessibilityConfiguration::init()
{
    LOGD() << "init, m_inited=" << m_inited;
    s_accessibilityActivationObserver = new AccessibilityActivationObserver();

    QAccessible::installActivationObserver(s_accessibilityActivationObserver);

    m_inited = true;
    LOGD() << "init done, isAccessibilityActive=" << s_accessibilityActivationObserver->isAccessibilityActive();
}

bool AccessibilityConfiguration::enabled() const
{
    bool result = false;
    if (!m_inited) {
        LOGD() << "enabled: false (not inited)";
        return false;
    }

    if (!navigationController()) {
        LOGD() << "enabled: false (no navigationController)";
        return false;
    }

    if (!active()) {
        LOGD() << "enabled: false (not active)";
        return false;
    }

    //! NOTE Accessibility available if navigation is used
    result = navigationController()->activeSection() != nullptr;
    LOGD() << "enabled: " << result << " (activeSection=" << (navigationController()->activeSection() ? "set" : "null") << ")";
    return result;
}

bool AccessibilityConfiguration::active() const
{
    if (!m_inited) {
        LOGD() << "active: false (not inited)";
        return false;
    }

    bool result = s_accessibilityActivationObserver->isAccessibilityActive();
    LOGD() << "active: " << result;
    return result;
}
