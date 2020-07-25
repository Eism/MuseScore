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
#ifndef MU_SCORES_SCORETHUMBNAIL_H
#define MU_SCORES_SCORETHUMBNAIL_H

#include <QQuickPaintedItem>
#include <QPainter>

namespace mu {
namespace scores {
class ScoreThumbnail : public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(int radius READ radius WRITE setRadius NOTIFY radiusChanged)

public:
    ScoreThumbnail(QQuickItem* parent = nullptr);

    int radius() const;

    Q_INVOKABLE void setThumbnail(QVariant pixmap);

public slots:
    void setRadius(int radius);

signals:
    void radiusChanged(int radius);

protected:
    virtual void paint(QPainter* painter) override;

private:
    QPixmap m_thumbnail;
    int m_radius = 0;
};
}
}

#endif // MU_SCORES_SCORETHUMBNAIL_H
