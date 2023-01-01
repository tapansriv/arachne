package org.arachne.collection;

/**
 * I just started writing comments and then his became an outline and I want to keep it
 *
 */
public class Outline {
    /**
     *
     * This class is going to do the following:
     *      1. Get and assign cardinalities to logical operators.
     *      2. Construct a working set of potential long-running ops
     *      3. Use card + set of ops to propose candidate splits
     *      4. Make the split, record times, use that information to make a new cut, and repeat this step
     *      5. Choose some end condition, less important right now
     *
     *  What's hard about this? 2 is very easy, 3 is also easy I think. We need to traverse the graph, using the info
     *  that we have, and make decisions. 4, making splits and running and collecting should be usable from existing code
     *  How do we want to end? Maybe just run for N iterations rn, we can come up with some better way later
     *
     *  1. We need to get cardinalities per operator and then link them to the operators. Easiest way to link would be
     *  to piggy back on ProfileRel, which would be nice, although I worry about losing common sub expr's that way.
     *  We'll have to see if detecting them is critical for this to work--i.e. if running the expanded query in SQL means
     *  that duckdb cannot make the same optimization or not (I assume they can, the ComSubExp is still there, just in SQL)
     *
     *  So lets get profileRel, then we need to do a match (could reuse the matching code--maybe tweak with card in mind:
     *  no match means just assume no change).
     *
     *
     *
     *  Steps: MAKE SURE TO REFERENCE MISC TODO, these are important points that need to be accounted for
     *  Steps: first, get the profile. we'll need to do some stitching together to get this to work. 13 hours indicates
     *  that we can start now-ish, and have it done by tomorrow afternoon. Should be enough time to get the rest working,
     *  and we can put in dummy values to do correctness validation.
     *      1. Get profiles for all 3 phases (1 done, 2 WIP)
     * DONE     1a. get profiles on chameleon
     *          1b. we need profiles on GCP too (at least initially, and verify that the 13 hour thing continues).
     * DONE 2. Stitch profiles together to form one large json file (needs some massaging/do in python/deserialize and manage, dont do it with strings)
     * DONE 3. Modify matching code to get cardinalities in there
     *      4. Write code to traverse the graph, identify place with sufficiently small data size + some candidate long-running ops afterwards
     *         Add in something to maybe check the total unique scanned data and if its too small just ignore this query--same thing with Duck runtime
     *      5. Propose a split, run, and get results back
     *      6. Write code to propose a new cut based on the results of the previous cut. Write out a procedure to handle
     *      7. Once the iterative process has concluded (MISC#10), actually run the splits and get some real cost data.
     *      8. parallel execution engine
     *      Then we'll be able to use cardinality and heuristics to iteratively profile and identify where a cut should occur for
     *      quasi-maximal savings. Then we'll be able to quantify what the actual cost of running that split is, and measure how close we are to
     *      our theoretical (but not necessarily optimal) cost.
     *
     *      It would be great to have some theoretical guarantees on error, accuracy, something to say that this does actually work
     *      as a procedure. We have plenty of reasons why other approaches aren't great, since we've tried them.
     *
     *
     *
     *
     *  Hack: for the window, we'll need to check if it's included in the cut and add that time to the end or something.
     *
     *  Misc things to do:
     *      1. need to handle window times (can't rerun it everytime). --what info do we need? profile (card), runtime (have)
     *      2. need to estimate row size better: use varchar in schemas, hold that info(?). Maybe global map between
     *         column name and size or something, since varchar varies obv. or encode it somehow? it'd also be nice to use
     *         the MQ? Although actually maybe not: we're not using the optimizer. just hack it
     *      4. get profile
     *      6. make a split
     *      7. decide how to cycle when we have profile info for a cut
     *      8. how do we estimate parquet size from table size? maybe profile it? part of the profiled query (for data mvmt)
     *      10. how do we end profiling process?
     *      11. I want to maybe find and split out common sub expressions. I worry that without this, we will expand that out and recompute it,
     *      and if we do find a benefit for any kind of split we'll offset it by repeating this major computation. This
     *      amounts to effectively reconstructing the CTE structure of things. This should be easy: before we start, find and separate it,
     *      then maybe profile it
     *
     *  Done:
     *      3. Request disk increase
     *      9. configurable data dir
     *          -- do fixed offset from home dir. then just do sys to get home dir
     *      5. match cardinality onto profile rels
     */
}
