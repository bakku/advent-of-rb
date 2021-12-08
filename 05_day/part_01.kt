import java.io.File

data class Line(val startX: Int, val startY: Int, val endX: Int, val endY: Int)

fun List<List<Int>>.toLine(): Line {
    val x1 = this[0][0]
    val y1 = this[0][1]
    val x2 = this[1][0]
    val y2 = this[1][1]

    return if (x1 == x2) Line(x1, minOf(y1, y2), x2, maxOf(y1, y2))
    else Line(minOf(x1, x2), y1, maxOf(x1, x2), y2)
}

fun initMatrix(lines: List<Line>): Array<Array<Int>> {
    val maxX = lines.maxOf { it.endX }
    val maxY = lines.maxOf { it.endY }

    return Array(maxX + 1) { Array(maxY + 1) { 0 } }
}

val lines = File("./input.txt")
    .readLines()
    .map { outer -> outer.split(" -> ").map { it.split(",").map(String::toInt) } }
    .filter { it[0][0] == it[1][0] || it[0][1] == it[1][1] }
    .map { it.toLine() }

val resultingMatrix = lines.fold(initMatrix(lines)) { matrix, line ->
    matrix.apply {
        if (line.startX == line.endX) (line.startY..line.endY).forEach { this[line.startX][it] += 1 }
        else (line.startX..line.endX).forEach { this[it][line.startY] += 1}
    }
}

println(resultingMatrix.flatten().count { it > 1 })
