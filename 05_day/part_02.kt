import java.io.File

interface Line {
    val startX: Int
    val startY: Int
    val endX: Int
    val endY: Int

    fun construct(): List<Pair<Int, Int>>
}

class VerticalLine(override val startX: Int, override val startY: Int,
                   override val endX: Int, override val endY: Int) : Line {
    override fun construct(): List<Pair<Int, Int>> {
        return if (startY < endY) (startY..endY).map { Pair(startX, it) }
        else (endY..startY).map { Pair(startX, it) }
    }
}

class HorizontalLine(override val startX: Int, override val startY: Int,
                     override val endX: Int, override val endY: Int) : Line {
    override fun construct(): List<Pair<Int, Int>> {
        return if (startX < endX) (startX..endX).map { Pair(it, startY) }
        else (endX..startX).map { Pair(it, startY) }
    }
}

class DiagonalLine(override val startX: Int, override val startY: Int,
                   override val endX: Int, override val endY: Int) : Line {
    override fun construct(): List<Pair<Int, Int>> {
        val xStep = if (startX < endX) 1 else -1
        val yStep = if (startY < endY) 1 else -1
        val pairList = mutableListOf<Pair<Int, Int>>()

        var currentX: Int = startX
        var currentY: Int = startY

        while (currentX != endX) {
            pairList.add(Pair(currentX, currentY))
            currentX += xStep
            currentY += yStep
        }

        pairList.add(Pair(currentX, currentY))

        return pairList
    }
}

fun List<List<Int>>.toLine(): Line {
    val x1 = this[0][0]
    val y1 = this[0][1]
    val x2 = this[1][0]
    val y2 = this[1][1]

    return if (x1 == x2) VerticalLine(x1, y1, x2, y2)
    else if (y1 == y2) HorizontalLine(x1, y1, x2, y2)
    else DiagonalLine(x1, y1, x2, y2)
}

fun initMatrix(lines: List<Line>): Array<Array<Int>> {
    val maxX = lines.maxOf { maxOf(it.startX, it.endX) }
    val maxY = lines.maxOf { maxOf(it.startY, it.endY) }

    return Array(maxY + 1) { Array(maxX + 1) { 0 } }
}

val lines = File("./input.txt")
    .readLines()
    .map { outer -> outer.split(" -> ").map { it.split(",").map(String::toInt) } }
    .map { it.toLine() }

val resultingMatrix = lines.fold(initMatrix(lines)) { matrix, line ->
    matrix.apply {
        line.construct().forEach { this[it.second][it.first] += 1 }
    }
}

println(resultingMatrix.flatten().count { it > 1 })