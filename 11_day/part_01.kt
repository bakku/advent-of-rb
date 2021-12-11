import java.io.File
import java.util.*

typealias OctopusGrid = List<List<Int>>
typealias GridPos = Pair<Int, Int>
data class StepResult(val grid: OctopusGrid, val flashes: Int)

fun topLeft(pos: GridPos) = Pair(pos.first - 1, pos.second - 1)
fun top(pos: GridPos) = Pair(pos.first, pos.second - 1)
fun topRight(pos: GridPos) = Pair(pos.first + 1, pos.second - 1)
fun left(pos: GridPos) = Pair(pos.first - 1, pos.second)
fun right(pos: GridPos) = Pair(pos.first + 1, pos.second)
fun bottomLeft(pos: GridPos) = Pair(pos.first - 1, pos.second + 1)
fun bottom(pos: GridPos) = Pair(pos.first, pos.second + 1)
fun bottomRight(pos: GridPos) = Pair(pos.first + 1, pos.second + 1)

fun getNeighbourOctopuses(grid: OctopusGrid, pos: GridPos): List<GridPos> {
    return listOf(topLeft(pos), top(pos), topRight(pos), left(pos), right(pos), bottomLeft(pos), bottom(pos), bottomRight(pos))
        .filter {
            it.first >= 0 && it.first <= grid.first().size - 1 &&
                    it.second >= 0 && it.second <= grid.size - 1 &&
                    grid[it.second][it.first] > 0 && grid[it.second][it.first] < 10
        }
}

fun flash(grid: OctopusGrid): StepResult {
    val mutableGrid = grid.map { it.toMutableList() }
    var noMoreFlashes = false
    var flashes = 0

    while (!noMoreFlashes) {
        noMoreFlashes = true

        mutableGrid.forEachIndexed { y, row ->
            row.forEachIndexed { x, energy ->
                if (energy == 10) {
                    flashes += 1
                    noMoreFlashes = false
                    mutableGrid[y][x] = 0

                    getNeighbourOctopuses(mutableGrid, Pair(x, y)).forEach { pos ->
                        mutableGrid[pos.second][pos.first] += 1
                    }
                }
            }
        }
    }

    return StepResult(Collections.unmodifiableList(mutableGrid), flashes)
}

fun singleStep(grid: OctopusGrid): StepResult {
    val incGrid = grid.map { row -> row.map(Int::inc) }
    return flash(incGrid)
}

fun executeSteps(grid: OctopusGrid, n: Int): StepResult {
    return (1..n).fold(StepResult(grid, 0)) { acc, _ ->
        val nextStepResult = singleStep(acc.grid)
        StepResult(nextStepResult.grid, acc.flashes + nextStepResult.flashes)
    }
}

val initialGrid = File("./input.txt")
    .readLines()
    .map { oit -> oit.map { it.toString().toInt() } }

println(executeSteps(initialGrid, 100).flashes)