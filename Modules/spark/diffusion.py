import numpy  
from pyspark import SparkContext

def simulation(sc, ncells, nsteps, nprocs, leftX=-10., rightX=+10.,  
               sigma=3., ao=1., coeff=.375):
    dx = (rightX-leftX)/(ncells-1)

    def tempFromIdx(i):
        x = leftX + dx*i + dx/2
        return (i, ao*numpy.exp(-x*x/(2.*sigma*sigma)))

    def interior(ix):                        # boilerplate
        return (ix[0] > 0) and (ix[0] < ncells-1)

    def stencil(item):
        i,t = item
        vals = [ (i,t) ] 
        cvals = [ (i, -2*coeff*t), (i-1, coeff*t), (i+1, coeff*t) ]
        return vals + filter(interior, cvals)

    temp = map(tempFromIdx,range(ncells))
    print temp
    #data= sc.parallelize(temp).partitionBy(nprocs, rangePartitioner)
    data= sc.parallelize(temp).partitionBy(nprocs)
    print "IC: "
    #print data.collect()
    for step in xrange(nsteps):
        print step
        stencilParts = data.flatMap(stencil)
        data = stencilParts.reduceByKey(lambda x, y:x+y)
    print "Final: "
    print data.collect()

if __name__ == "__main__":  
    #sc = SparkContext("local[*]", appName="SparkDiffusion")
    sc = SparkContext(appName="SparkDiffusion")
    sc.setLogLevel("OFF")
    print "number of cores = ", sc.defaultParallelism
    simulation(sc, 10, 20, 4)
