#include "scorethumbnail.h"

#include <QVariant>

using namespace mu::scores;

ScoreThumbnail::ScoreThumbnail(QQuickItem* parent)
    : QQuickPaintedItem(parent)
{
}

int ScoreThumbnail::radius() const
{
    return m_radius;
}

void ScoreThumbnail::setRadius(int radius)
{
    if (m_radius == radius) {
        return;
    }

    m_radius = radius;
    radiusChanged(radius);
}

void ScoreThumbnail::setThumbnail(QVariant pixmap)
{
    if (pixmap.isNull()) {
        return;
    }

    m_thumbnail = pixmap.value<QPixmap>();
    update();
}

void ScoreThumbnail::paint(QPainter* painter)
{
    QBrush brush = QBrush(m_thumbnail);

    painter->setBrush(brush);
    painter->setPen(Qt::NoPen);
    painter->drawRoundedRect(0, 0, width(), height(), m_radius, m_radius);
}
