/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore
 * Music Composition & Notation
 *
 * Copyright (C) 2021 MuseScore BVBA and others
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

#ifndef MU_DOCK_DOCKTOOLBAR_H
#define MU_DOCK_DOCKTOOLBAR_H

#include "internal/dockbase.h"

namespace mu::dock {
class DockToolBar : public DockBase
{
    Q_OBJECT

    Q_PROPERTY(bool movable READ movable WRITE setMovable NOTIFY movableChanged)
    Q_PROPERTY(Qt::Orientation orientation READ orientation WRITE setOrientation NOTIFY orientationChanged)

    Q_PROPERTY(QSize horizontalPreferedSize READ horizontalPreferedSize WRITE setHorizontalPreferedSize NOTIFY horizontalPreferedSizeChanged)
    Q_PROPERTY(QSize verticalPreferedSize READ verticalPreferedSize WRITE setVerticalPreferedSize NOTIFY verticalPreferedSizeChanged)

public:
    explicit DockToolBar(QQuickItem* parent = nullptr);

    bool movable() const;
    Qt::Orientation orientation() const;

    Q_INVOKABLE void setDraggableMouseArea(QQuickItem* mouseArea);

    QSize horizontalPreferedSize() const;
    QSize verticalPreferedSize() const;

public slots:
    void setMinimumWidth(int width) override;
    void setMinimumHeight(int height) override;
    void setMaximumWidth(int width) override;
    void setMaximumHeight(int height) override;

    void setMovable(bool movable);
    void setOrientation(Qt::Orientation orientation);

    void setHorizontalPreferedSize(QSize horizontalPreferedSize);
    void setVerticalPreferedSize(QSize verticalPreferedSize);

signals:
    void movableChanged(bool movable);
    void orientationChanged(Qt::Orientation orientation);

    void horizontalPreferedSizeChanged(QSize horizontalPreferedSize);
    void verticalPreferedSizeChanged(QSize verticalPreferedSize);

private slots:
    void updateOrientation();

private:
    void componentComplete() override;
    DockType type() const override;
    QRect dragRect() const override;

    class DraggableArea;
    DraggableArea* m_draggableArea = nullptr;

    bool m_movable = true;
    Qt::Orientation m_orientation = Qt::Horizontal;
    QSize m_horizontalPreferedSize;
    QSize m_verticalPreferedSize;
};
}

#endif // MU_DOCK_DOCKTOOLBAR_H
